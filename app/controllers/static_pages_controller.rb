class StaticPagesController < ApplicationController
  def home
    if signed_in?
      track_user(request.remote_addr, RedisHelper::UserType::LOGIN)
    else
      track_user(request.remote_addr, RedisHelper::UserType::ANONY)
    end
  end

  def help
  end
end
