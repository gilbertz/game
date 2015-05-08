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
    $wxclient.send_text_custom("oRKD0s8stWW-DUiWIKDKV22qaUVI","1245wwwwww")

    $wxclient1.send_text_custom("oNnqbt_LiqkMXMrzHEawO-G9r8Vo","1245wwwwww")
    $wxclient1.send_template_msg("oNnqbt_LiqkMXMrzHEawO-G9r8Vo", "hMQm4-BGvNX-XIRQnfb_MG3EP6AFCDEFJ0gPrBX7oeg", "http://www.dapeimishu.com/", "#FF0000",  "data"=>{
        "first"=> {
            "value"=>"恭喜你购买成功！",
            "color"=>"#173177"
        },
        "keynote1"=>{
        "value"=>"巧克力",
        "color"=>"#173177"
    },
        "keynote2"=>{
        "value"=>"39.8元",
        "color"=>"#173177"
    },
        "keynote3"=> {
        "value"=>"2014年9月16日",
        "color"=>"#173177"
    },
        "remark"=>{
        "value"=>"欢迎再次购买！",
        "color"=>"#173177"
    }
    })

    render :json => result.to_json
  end
end
