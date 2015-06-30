if Rails.env.development?
  redis_host = '127.0.0.1'
else
  redis_host = '211ba332fe0a11e4.m.cnqda.kvstore.aliyuncs.com'
end
Sidekiq.configure_server do |config|
  config.redis = {:url => "redis://#{redis_host}:6379/12", :namespace => 'sidekiq'}
end

Sidekiq.configure_client do |config|
  config.redis = {:url => "redis://#{redis_host}:6379/12", :namespace => 'sidekiq'}
end

Sidekiq.default_worker_options = { 'backtrace' => true }