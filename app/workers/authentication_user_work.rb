class AuthenticationUserWork

  include Sidekiq::Worker

  def perform(authentication_appid,component_appid)
    $redis.set("f",4)
    p "xxxxx========"

  end

end
