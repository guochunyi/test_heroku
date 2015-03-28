class StaticPagesController < ApplicationController
  def home
    track_user(request.remote_addr, RedisHelper::UserType::ANONY)
  end

  def help
  end
end
