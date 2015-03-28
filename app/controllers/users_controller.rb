class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find params[:id]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user

      delete_online_user(request.remote_addr, RedisHelper::UserType::ANONY)
      view_time_expire(request.remote_addr)
      
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation)
  end

end