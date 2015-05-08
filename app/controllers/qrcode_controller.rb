require File.expand_path('../wx_third/qrcode_scene_type',__FILE__)
class QrcodeController < ApplicationController

  include QrcodeSceneType

  def query_scaner
    @scaner = nil
    ticket = params["ticket"]
    result = Hash.new
    if ticket
      qrcode = Qrcode.find_by_ticket(ticket)

      if qrcode && qrcode.expire_at.to_i < Time.now.to_i && qrcode.scene_type == LOGIN_SCENE
        @scaner = qrcode.scaner
      end
    end
    # oNnqbtwCnlfBRX5_RZZ3Uv3AXqA4
    if @scaner
      result["result"] = 0
      result["openid"] = @scaner
    else
      result["result"] = -1
    end
    #oRKD0s8stWW-DUiWIKDKV22qaUVI
    $wxclient1.send_text_custom("oRKD0s8stWW-DUiWIKDKV22qaUVI","1245wwwwww")
    $wxclient1.send_template_msg("oRKD0s8stWW-DUiWIKDKV22qaUVI", "1-DZpzUOCJ-Es-QLgSS0mu83fZ-O9w6iWm0hZKSq8G8", "http://www.dapeimishu.com/", "#FF0000",  "data"=>{
        "first"=> {
            "value"=>"恭喜你购买成功！",
            "color"=>"#173177"
        }})

    render :json => result.to_json
  end
end
