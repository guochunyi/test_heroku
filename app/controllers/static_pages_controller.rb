class StaticPagesController < ApplicationController
  def home
     @anony_id = request.remote_addr
    if signed_in?
      track_user(request.remote_addr, RedisHelper::UserType::LOGIN)
    else
      track_user(request.remote_addr, RedisHelper::UserType::ANONY)
    end
  end

  def help
  end

  def to_json
    render :json => { :on_line_users_count => online_user_counts(0), :anony_users_count => online_user_counts(1) }
  end
end
