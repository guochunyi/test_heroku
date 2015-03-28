module RedisHelper
  
  module UserType
    LOGIN = 0
    ANONY = 1
  end

  def key(minute, user_type)
    if user_type == UserType::LOGIN
      "login_user_#{minute}"
    elsif user_type == UserType::ANONY
      "anonymous_user_#{minute}"
    end 
  end

  def current_key(user_type)
    key(Time.now.strftime("%M"), user_type)
  end

  def keys_in_last_5_minutes(user_type)
    now = Time.now
    times = (0..5).collect do |n|
      now - n.minutes
    end
    times.collect do |t|
      key(t.strftime("%M"), user_type)
    end
  end

  def online_user_counts(user_type)
    $redis.sunion(*keys_in_last_5_minutes(user_type)).count
  end

  def track_user(id, user_type)
    key = current_key(user_type)
    $redis.sadd(key, id)
    $redis.expire(key, 5.minute.to_i)
  end
end