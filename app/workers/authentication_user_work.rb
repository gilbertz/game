require File.expand_path('../../wx_third/wx_util',__FILE__)
class AuthenticationUserWork

  include Sidekiq::Worker

  def perform(authentication_appid,component_appid)
    $redis.set("f",40)
    p "xxxxx========"

    WxUtil.save_users(authentication_appid)

  end

end
