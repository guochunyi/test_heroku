class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in(user)

      delete_online_user(request.remote_addr, RedisHelper::UserType::ANONY)
      view_time_expire(request.remote_addr)

      track_user(current_user.id, RedisHelper::UserType::LOGIN)
      redirect_to root_url
    else
      flash[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  def destroy
    current_login_time = current_user.login_time + login_view_time(current_user.id)
    current_user.update(login_time: current_login_time)
    
    delete_online_user(current_user.id, RedisHelper::UserType::LOGIN)
    view_time_expire(current_user.id)

    sign_out
    redirect_to root_path
  end 
end