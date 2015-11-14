class PasswordResetsController < ApplicationController
  def new
    flash.clear()
    flash[:notice] = 'Please, input your email address in box below.'
  end

  def create
    admin = Admin.find_by_email(params[:email])
    admin.send_password_reset if admin
    redirect_to root_url, notice: "Email for #{params[:email]} was sent with password reset instructions."
  end

  def edit
    @admin = Admin.find_by_password_reset_token!(params[:id])
  end

  def update
    @admin = Admin.find_by_password_reset_token!(params[:id])
    if @admin.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: 'Password reset has expired.'
    elsif @admin.update_attributes(admin_params)
      redirect_to root_url, notice: 'Password has been reset.'
    else
      render :edit
    end
  end

  private
    def admin_params
      params.require(:admin).permit(:password, :password_confirmation)
    end
end
