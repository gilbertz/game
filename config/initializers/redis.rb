require 'redis'

if Rails.env.production?
  REDIS_HOST = '121.42.47.121'
else
  REDIS_HOST = 'localhost'
end

$redis =  Redis.new(:host => REDIS_HOST, :port => 6379)
