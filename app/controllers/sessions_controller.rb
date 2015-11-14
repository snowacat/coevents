class SessionsController < ApplicationController
  # Count allowable attempts for login
  ALLOWABLE_ATTEMPTS = 3

  def new
  end

  def create
    session[:count_bad_login] = 0 if session[:count_bad_login].nil?
    session[:count_bad_login] += 1
    if session[:count_bad_login] >= ALLOWABLE_ATTEMPTS
      @showCaptcha = true
    end
    if session[:count_bad_login] > ALLOWABLE_ATTEMPTS
      # If reCaptcha is valid
      if recaptcha_valid?
        login
      else
        flash[:error] = 'Captcha has wrong, try again.'
        render :new
      end
    else
      login
    end
  end

  # GET
  # Button cancel
  def cancel
    flash.clear()
    redirect_to login_path
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to login_path, notice: 'Logged Out'
  end

  def login
    admin = Admin.find_by_login(params[:login])
    if admin && admin.authenticate(params[:password])
      generate_remember_token(admin)
      if params[:remember_me]
        cookies.permanent[:auth_token] = admin.auth_token
      else
        cookies[:auth_token] = admin.auth_token
      end
      flash[:notice] = "Hello, #{params[:login]}!"

      # Set the counter BadLogin to default value
      session[:count_bad_login] = nil
      @showCaptcha = false

      redirect_to admin_url
    else
      flash[:error] = 'Please, check your login or password.'
      render :new
    end
  end
end
