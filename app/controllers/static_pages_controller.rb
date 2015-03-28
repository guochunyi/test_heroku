class StaticPagesController < ApplicationController
  def home
     @anony_id = request.remote_addr
    if signed_in?
      track_user(current_user.id, RedisHelper::UserType::LOGIN)
      @current_login_time = current_user.login_time + login_view_time(current_user.id)
    else
      track_user(request.remote_addr, RedisHelper::UserType::ANONY)
    end
  end

  def to_json
    render :json => { :on_line_users_count => online_user_counts(0), :anony_users_count => online_user_counts(1) }
  end
end
