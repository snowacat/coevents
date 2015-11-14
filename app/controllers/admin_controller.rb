class AdminController < ApplicationController
  before_filter :authorize
  helper_method :sort_column, :sort_direction

  # Count events for one page
  COUNT_EVENTS = 5
  # Count users for one page
  COUNT_USERS = 10
  # Count Categories for one page
  COUNT_CATEGORIES = 20

  # Main home page for all users
  def index
    render file: 'public/index.html'
  end

  def show
  end

  # GET
  # Get event list
  def event
    if params[:send_message]
      @event = Event.where("send_message = ?", params[:send_message])
                    .order(sort_column + ' ' + sort_direction)
                    .paginate(per_page: COUNT_EVENTS, page: params[:page])
    else
      @event = Event.order(sort_column + ' ' + sort_direction)
                    .paginate(per_page: COUNT_EVENTS, page: params[:page])
    end
  end

  def category
    @categories = Category.all.order(sort_column + ' ' + sort_direction)
                              .paginate(per_page: COUNT_CATEGORIES, page: params[:page])
    @categories_all = Category.all
  end

  def edit_category
    # Default error value
    @error_fields = ''
    if params[:id].nil?
      @category = Category.new
    else
      @category = Category.where("categories.id = ?", params[:id]).first
    end
  end

  def update_category
    if params[:category_id].present?
      category = Category.find_by_id(params[:category_id])

      params[:parent] =  params[:category_parent][:id] if params[:category_parent][:id]

      if params[:parent] == category.id
        params[:parent] = nil
        flash[:error] = 'Category parent cant be the same!'
        return redirect_to action: :category
      end

      if category.update(category_params)
        flash[:notice] = 'Successfully updated!'
        redirect_to action: :category
      else
        get_error(category)
        redirect_to action: :edit_category
      end
    else
      category = Category.new(category_params)
      if category.invalid?
        get_error(category)
        redirect_to action: :edit_category
      elsif category.save
        flash[:notice] = 'Successfully created!'
        redirect_to action: :category
      else
        get_error(category)
        redirect_to action: :edit_category
      end
    end
  end

  # GET
  # Get user list
  def user
    @users = User.order(sort_column + ' ' + sort_direction)
                 .paginate(per_page: COUNT_USERS, page: params[:page])
  end

  # GET
  # Create/Update user
  def update
    @error_fields = ''
    if params[:id].nil? && cookies[:user_name].nil?
      @user = User.new
    elsif params[:id]
      @user = User.find_by_id(params[:id])
    else
      @user = User.new
      # Get values from cookies for update form
      @user.assign_attributes(id: cookies[:user_id],
                              user_name: cookies[:user_name],
                              email: cookies[:email],
                              phone_number: cookies[:phone_number],
                              gender: cookies[:gender],
                              birthdate: cookies[:birthdate],
                              verified: cookies[:verified],
                              nationality: cookies[:nationality]
      )

      @error_fields = cookies[:errors]
      delete_cookies
    end
  end

  # GET
  # Create/Update event
  def edit
    # Get errors
    @error_fields = ''
    @error_fields = cookies[:errors] if cookies[:errors]

    if params[:id].nil?
      @event = Event.new
      get_event_params_from_cookies
    else
      @event = Event.where("events.id = ?", params[:id]).first
      # Get list users
      @list = @event.users.map(&:id)
    end
  end

  # POST
  # Create/Update user
  def user_update
    if params[:user_id].present?
      user = User.find_by_id(params[:user_id])

      if user.update(user_params)
        flash[:notice] = 'Successfully updated!'
        redirect_to action: :user
      else
        get_error(user)
        save_data_fields
        redirect_to action: :update
      end
    else
      user = User.new(user_params)
      if user.invalid?
        get_error(user)
        save_data_fields
        redirect_to action: :update
      elsif user.save
        flash[:notice] = 'Successfully created!'
        redirect_to action: :user
      else
        save_data_fields
        get_error(user)
        redirect_to action: :update
      end
    end
  end

  # POST
  # Send notifications for users
  def send_notifications
    if params[:id]
      event = Event.includes(:users).find_by_id(params[:id])

      unless event
        flash[:error] = 'Event not found!'
        return redirect_to action: :event
      end

      # Count users, who receive sms message
      count_users = 0

      event.users.each do |user|
        # Send sms
        if user.phone_number && user.phone_number.present?
          count_users = count_users + 1 if send_message(user.phone_number)

          # Change status for this event
          event.send_message = true
          event.save
        end

        # Send email
        send_email(user.email)
      end

      flash[:notice] = "Count users, who received sms: #{count_users.to_s}"
      redirect_to action: :event
    end
  end

  # POST
  # Create/Update event
  def create
    # Update if event id not null and create if we have event id
    if params[:id] != ''
      event = Event.find_by_id(params[:id])
      if event.update(event_params)
        # Remove old participant
        UserEvent.where(event_id: event.id).destroy_all
        # Insert new participants
        save_new_participant(event.id) if params[:users][:id]

        delete_cookies

        flash[:notice] = 'Successfully updated!'
        redirect_to action: :event
      else
        flash[:notice] = 'Failed update!'
        redirect_to action: :event
      end
    else
      event = Event.new(event_params)

      if event.invalid?
        save_events_param
        get_error(event)
        redirect_to action: :create
      elsif event.save
        # Insert new participants
        save_new_participant(event.id) if params[:users][:id]
        # Remove old cookies
        delete_cookies
        flash[:notice] = 'Successfully created!'
        redirect_to action: :event
      else
        get_error(event)
        redirect_to action: :create
      end
    end
  end

  # POST
  # Remove event
  def destroy
    event = Event.find_by_id(params[:id])
    if event.nil?
      flash[:error] = 'Failed to destroy.'
    else
      event.destroy
      flash[:notice] = 'Successfully removed.'
    end
    redirect_to action: :event
  end

  # POST
  def category_destroy
    category = Category.find_by_id(params[:id])
    if category.nil?
      flash[:error] = 'Failed to destroy.'
    else
      category.destroy
      flash[:notice] = 'Successfully removed.'
    end

    redirect_to action: :category
  end

  # Find users
  def find_users
    # Get old values
    cookies[:name_user] = params[:name_user]
    cookies[:email_user] = params[:email_user]

    if (params[:email_user] == '' || params[:email_user].nil?) && (params[:name_user] == '' || params[:name_user].nil?)
      flash[:error] = 'User email or name is nil! Please input email or user name.'
      cookies.delete :email_user
      cookies.delete :name_user

      return redirect_to action: :user
    end

    @users = User.where("users.email = ? OR users.user_name = ?", params[:email_user], params[:name_user])
                 .order(sort_column + ' ' + sort_direction)
                 .paginate(per_page: COUNT_USERS, page: params[:page])

    unless @users.present?
      flash[:errors] = 'Not found user with this email or user name'

      return redirect_to action: :user
    end

    # Set error as nil
    @error_fields = ''

    render 'user'
  end

  # Post
  # Destroy user
  def destroy_user
    user = User.find_by_id(params[:id])
    if user.nil?
      flash[:error] = 'Failed to destroy this user.'
    else
      user.destroy
      flash[:notice] = 'Successfully removed.'
    end

    redirect_to action: :user
  end


  private
    def send_message(user_number)
      message_body = <<-SMS
              Hello! You have one new event! Look more on www.coevents.ru
      SMS

      begin
        twilio.account.messages.create({
           from: '+19493835893',
           to: user_number.to_s,
           body: message_body
       })
        return true
      rescue => e
        notifications_logger.error("Error! Sms Logger: #{e.message}")
        return false
      end
    end

    def send_email(user_email)
      begin
        RestClient.post "https://api:key-dcb3654a4c52d10940cc2003cc4b60fd"\
                        "@api.mailgun.net/v3/sandbox7164cc26973446e1903cef08f072b2af.mailgun.org/messages",
                        from: "CoEvents <postmaster@sandbox7164cc26973446e1903cef08f072b2af.mailgun.org>",
                        to: "<#{user_email}>",
                        subject: 'New your event',
                        text: 'Hello! You have one new event! Look more on http://www.coevents.ru'
        return true
      rescue => e
        notifications_logger.info("Email Logger: #{e.message}")
        return false
      end
    end

    def notifications_logger
      @@notifications_logger ||= Logger.new("#{Rails.root}/log/notifications_logger.log")
    end

    def save_new_participant(event_id)
      params[:users][:id].each do |id|
        UserEvent.new(user_id: id, event_id: event_id).save if id.present?
      end
    end

    # Get error messages
    def get_error(object)
      flash[:error] = ''
      object.errors.each do |attr, msg|
        flash[:error] << msg + ' '
      end

      cookies[:errors] = flash[:error]
    end

    def save_category_params
      cookies[:category_id] = params[:id]
      cookies[:title] = params[:title]
    end

    def clear_category_params
      cookies.delete :category_id
      cookies.delete :title
    end

    def save_data_fields
      cookies[:user_name] = params[:user_name]
      cookies[:email] = params[:email]
      cookies[:phone_number] = params[:phone_number]
      cookies[:gender] = params[:gender]
      cookies[:birthdate] = params[:birthdate]
      cookies[:verified] = params[:verified]
      cookies[:errors] = flash[:error]
      cookies[:user_id] = params[:user_id]
      cookies[:nationality] = params[:nationality]
    end

    def delete_cookies
      cookies.delete :user_name
      cookies.delete :email
      cookies.delete :phone_number
      cookies.delete :gender
      cookies.delete :birthdate
      cookies.delete :verified
      cookies.delete :listError
      cookies.delete :errors
      cookies.delete :user_id
      cookies.delete :nationality

      # Event cookies
      cookies.delete :event_title
      cookies.delete :event_content
      cookies.delete :event_start_date
      cookies.delete :event_end_date
      cookies.delete :event_latitude
      cookies.delete :event_longitude
      cookies.delete :event_address
      cookies.delete :event_category_id
      cookies.delete :event_paid
      cookies.delete :event_payment_amount
    end

    def save_events_param
      cookies[:event_title] = params[:title]
      cookies[:event_content] = params[:content]
      cookies[:event_start_date] = params[:start_date]
      cookies[:event_end_date] = params[:end_date]
      cookies[:event_latitude] = params[:latitude]
      cookies[:event_longitude] = params[:longitude]
      cookies[:event_address] = params[:address]
      cookies[:event_category_id] = params[:category_id]
      cookies[:event_paid] = params[:paid]
      cookies[:event_payment_amount] = params[:payment_amount]
    end

    def get_event_params_from_cookies
      @event.title = cookies[:event_title] if cookies[:event_title]
      @event.content = cookies[:event_content] if cookies[:event_content]

      @event.start_date = cookies[:event_start_date] if cookies[:event_start_date]
      @event.end_date = cookies[:event_end_date] if cookies[:event_end_date]

      @event.latitude = cookies[:event_latitude] if cookies[:event_latitude]
      @event.longitude = cookies[:event_longitude] if cookies[:event_longitude]

      @event.address = cookies[:event_address] if cookies[:event_address]
      @event.category_id = cookies[:event_category_id] if cookies[:event_category_id]

      @event.paid = cookies[:event_paid] if cookies[:event_paid]
      @event.payment_amount = cookies[:event_payment_amount] if cookies[:event_payment_amount]
    end

    def event_params
      if params[:paid].nil?
        params[:paid] = false
        params[:payment_amount] = nil
        params[:send_message] = false
      end

      # Get category ID from selected option
      params[:category_id] = params[:category][:id] if params[:category]
      params[:content] = params[:event][:content]
      params[:send_message] = params[:message_send]

      params.permit(:title,
                    :content,
                    :paid,
                    :payment_amount,
                    :start_date,
                    :end_date,
                    :approve,
                    :send_message,
                    :latitude,
                    :longitude,
                    :address,
                    :category_id
      )
    end

    def category_params
      params[:parent] = params[:category_parent][:parent]
      params.permit(:title, :parent)
    end

    def user_params
      params[:verified].nil? ? 'false' : true

      params.permit(:email,
                    :user_name,
                    :phone_number,
                    :password,
                    :password_confirmation,
                    :nationality,
                    :language,
                    :gender,
                    :birthdate,
                    :verified,
                    :nationality
      )
    end


    def sort_column
      params[:sort].nil? ? 'id' : params[:sort]
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
