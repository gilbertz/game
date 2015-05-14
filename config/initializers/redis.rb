require 'redis'


$redis =  Redis.new(:host => REDIS_HOST, :port => 6379)
