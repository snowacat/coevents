class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include Rack::Recaptcha::Helpers
  helper_method :current_admin
  helper_method :admin?

  protected

  # Check auth token from db and cookies
  def admin?
    if current_admin.nil?
      false
    else
      true
    end
  end

  def authorize
    unless admin?
      flash[:error] = 'Please, input your login and password!'

      redirect_to login_path
    end
  end
end
