require File.expand_path('../base_worker',__FILE__)
require File.expand_path('../../controllers/wx_third/wx_util',__FILE__)

class AuthenticationCardWork < BaseWorker

  def perform(authentication_appid,component_appid)

    $redis.set("h",102)
    WxUtil.deal_card(authentication_appid)
  end


end