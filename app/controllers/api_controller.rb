class ApiController < ActionController::Base
  before_action :set_locale
  before_filter :set_default_response_format

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end


protected
  def restrict_to_development
    head(:bad_request) unless Rails.env.development?
  end

  def set_default_response_format
    request.format = :json
  end


private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize
    render nothing: true, status: :unauthorized if current_user.nil?
  end

  def pages_params
    items_per_page = params[:items_per_page].nil? ? 10 : params[:items_per_page].to_i
    {
      page: params[:page].nil? ? 0 : (params[:page].to_i - 1) * items_per_page,
      items_per_page: items_per_page
    }
  end

  def twilio
    require 'rubygems'
    require 'twilio-ruby'

    @twilio_client ||= Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_SECRET']
  end
end