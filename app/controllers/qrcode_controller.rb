require File.expand_path('../wx_third/qrcode_scene_type',__FILE__)
require File.expand_path('../wx_third/wx_qrcode',__FILE__)

class QrcodeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  include QrcodeSceneType
  include WxQrcode

  def query_scaner
    @scaner = nil
    ticket = params["ticket"]
    result = Hash.new
    if ticket != nil
      qrcode = Qrcode.find_by_ticket(ticket)

      p "qrcode #{qrcode.to_json}"
      if qrcode && qrcode.expire_at.to_i >= Time.now.to_i && qrcode.scene_type == LOGIN_SCENE
        @scaner = qrcode.scaner
      end
    end
    # oNnqbtwCnlfBRX5_RZZ3Uv3AXqA4
    if @scaner
      p "if scanner"

      result["result"] = 0
      result["openid"] = @scaner
      $wxclient1.send_text_custom(@scaner,"您已经成功登陆疯狂摇一摇")

    else
      result["result"] = -1
    end
    #oRKD0s8stWW-DUiWIKDKV22qaUVI

    #$wxclient.send_text_custom("oRKD0s8stWW-DUiWIKDKV22qaUVI","1245wwwwww")

    #$wxclient1.send_text_custom("oNnqbt_LiqkMXMrzHEawO-G9r8Vo","1245wwwwww")
    #data = {first:{value:"活动即将开始",color:"#173177"},keyword1:{value:"chentao",color:"#173177"},keyword2:{value:"德高巴士活动",color:"#173177"},keyword3:{value:"2014年9月16日",color:"#173177"}}
    #$wxclient1.send_template_msg("oNnqbt_LiqkMXMrzHEawO-G9r8Vo", "hMQm4-BGvNX-XIRQnfb_MG3EP6AFCDEFJ0gPrBX7oeg", "http://www.dapeimishu.com/", "#FF0000", data)

    render :json => result.to_json
  end




end
