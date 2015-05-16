require File.expand_path('../../controllers/wx_third/wx_util',__FILE__)
require File.expand_path('../base_worker',__FILE__)

class AuthenticationUserWork < BaseWorker

  def perform(authentication_appid,component_appid)
    WxUtil.save_users(authentication_appid)
  end

end
