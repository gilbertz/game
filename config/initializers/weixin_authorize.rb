require 'redis'
require 'redis-namespace'
# 这里修改成你的的命名空间。
namespace = "ibeacon:weixin_authorize"

redis  = nil
if Rails.env.production?
  REDIS_HOST = '211ba332fe0a11e4.m.cnqda.kvstore.aliyuncs.com'
  redis =  Redis.new(:host => REDIS_HOST,:password => '211ba332fe0a11e4:Dapei123', :port => 6379)
else
  REDIS_HOST = 'localhost'
  redis =  Redis.new(:host => REDIS_HOST, :port => 6379)
end

# 每次重启时，会把当前的命令空间所有的access_token 清除掉。
exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

# Give a special namespace as prefix for Redis key, when your have more than one project used weixin_authorize, this config will make them work fine.
# => #<Redis client v3.1.0 for redis://127.0.0.1:6379/0>
# namespaced_redis = Redis::Namespace.new("#{namespace}", :redis => redis)

WeixinAuthorize.configure do |config|
  config.redis = redis
end