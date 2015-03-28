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

  def anony_view_time(id)
    if $redis.get(id) == nil
      $redis.set(id, Time.now)
      $redis.expire(id, 5.minute.to_i)
      0
    else
      $redis.expire(id, 5.minute.to_i)
      (Time.now - $redis.get(id).to_time).to_i / 60
    end
  end

  def delete_online_user(id, user_type)
    keys_in_last_5_minutes(user_type).each do |e|
      $redis.srem(e, id)
    end
  end

  def login_view_time(id)
    if $redis.get(id) == nil
      $redis.set(id, Time.now) 
      0
    else
      (Time.now - $redis.get(id).to_time).to_i / 60
    end
  end

  def view_time_expire(id)
    $redis.del(id)
  end
end