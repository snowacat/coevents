class EventsController < ApiController
  # Count events for one page
  COUNT_EVENTS = 10

  # GET
  # Get events for first page
  # Path: /event/show/1
  # 1 - It's page number
  def show
    events = Event.order('updated_at desc').paginate(page: params[:id], per_page: COUNT_EVENTS)
    render json: events.as_json(only: [:id, :title, :content, :latitude, :longitude, :created_at], include: [:users])
  end

  # GET
  # Get participant events
  # Path: /event/participant/1/2
  # 1 - participant id, 2 - page number
  def participant
    user = User.find_by_id(params[:id])
    if user.nil?
      render json: []
    else
      render json: user.events.as_json(include: [:users])
    end
  end

  # GET
  # Get events from category
  # Path: /event/category/1/2
  # 1 - Category Id, 2 - page number
  def category
    # Searching category
    category = Category.find_by_id(params[:id])
    if category.nil?
      render json: []
    else
      categoryEvents = category.events.paginate(page: params[:page], per_page: COUNT_EVENTS)
      if  categoryEvents.nil?
        render json: 1
      else
        render json: categoryEvents.as_json(include: [:users])
      end
    end
  end

  # GET
  # Get all category
  # Path: /event/navigation
  def navigation
    render json: Category.all
  end

  # GET
  # Get all authors
  # Path: /event/participants
  def participants
    render json: User.all
  end

  # Get count Categories, events and users
  def statistics
    count_users = User.count
    count_events = Event.count
    count_category = Category.count

    json_answer = [
        users: count_users,
        events: count_events,
        categories: count_category
    ]

    render json: json_answer
  end

  # Get count Users, who subscribed to event
  def count_users_event
    events = Event.includes(:users).limit(5)

    summary = []

    events.each do |event|
      if event.users.count != 0
        statistic = {
            x: event.title,
            y: [ event.users.count ]
        }

        summary << statistic
      end
    end

     render json: summary
  end
end