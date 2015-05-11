require File.expand_path('../qrcode_type',__FILE__)
require File.expand_path('../qrcode_scene_type',__FILE__)

module WxQrcode

  include QrcodeSceneType
  include QrcodeType

  def generate_qr(access_token,appid= WX_APPID,is_tempoart = true)
    if access_token.blank?
      return nil
    end
    url = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{access_token}"
    post_data = nil
    action_name = nil
    expire_at = nil
    scene_id = Time.new.to_i
    if is_tempoart
      action_name = QR_SCENE
      expire_at = Time.now + 1800
      p "expire_at = #{expire_at}"
      post_data = {"expire_seconds"=> 1800, "action_name"=> "QR_SCENE", "action_info"=> {"scene"=> {"scene_id"=> scene_id}}}
    else
      action_name = QR_LIMIT_SCENE
      post_data = {"action_name"=> "QR_LIMIT_SCENE", "action_info" => {"scene" => {"scene_id"=> scene_id}}}
    end

    res = RestClient::post(url,post_data.to_json)
    ret = JSON.parse(res.body)
    p "generate_temporary_qr #{ret}"
    if ret["ticket"] != nil
      qrcode = Qrcode.new
      qrcode.wx_authorizer_id = appid
      qrcode.url = ret["url"]
      qrcode.ticket = ret["ticket"]
      qrcode.action_name = action_name
      qrcode.provide = "weixin"
      qrcode.scene_id = scene_id
      qrcode.qrcode_url = qrcode_url(ret["ticket"])
      qrcode.scene_type = LOGIN_SCENE
      qrcode.expire_at = expire_at
      qrcode.save
      return qrcode
    end

    return nil

  end


end