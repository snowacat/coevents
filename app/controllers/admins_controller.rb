class AdminsController < ApplicationController
  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(user_params)
    if @admin.save
      redirect_to root_url, notice: 'Signed Up'
    else
      render :new
    end
  end


  private
    def user_params
      params.require(:admin).permit(:login, :password, :password_confirmation)
    end
end
