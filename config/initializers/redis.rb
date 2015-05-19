require 'redis'

$redis = nil
if Rails.env.production?
  REDIS_HOST = '211ba332fe0a11e4.m.cnqda.kvstore.aliyuncs.com'
  $redis =  Redis.new(:host => REDIS_HOST,:password => '211ba332fe0a11e4:Dapei123', :port => 6379)
else
  REDIS_HOST = 'localhost'
  $redis =  Redis.new(:host => REDIS_HOST, :port => 6379)
end

