require File.expand_path('../base_worker',__FILE__)
require File.expand_path('../../controllers/wx_third/wx_util',__FILE__)

class AuthenticationCardWork < BaseWorker

  def perform(authentication_appid,component_appid)

    WxUtil.deal_card(authentication_appid)
  end


end