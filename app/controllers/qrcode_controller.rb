require File.expand_path('../qrcode_scene_type',__FILE__)
class QrcodeController < ApplicationController

  include QrcodeSceneType
  def query_scaner
    @scaner = nil
    ticket = params["ticket"]
    if ticket
      qrcode = Qrcode.find_by_ticket(ticket)

      if qrcode && qrcode.expire_at.to_i < Time.now.to_i && qrcode.scene_type == LOGIN_SCENE
        @scaner = qrcode.scaner
      end
    end

    if @scaner
      redirect_to "http://www.baidu.com"
    end

  end
end
