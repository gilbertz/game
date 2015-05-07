module WxQrcode

  def generate_qr(appid,access_token,is_tempoart = true)
    if access_token.blank?
      return nil
    end
    url = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{access_token}"
    post_data = nil
    if is_tempoart
      post_data = {"expire_seconds"=> 604800, "action_name"=> "QR_SCENE", "action_info"=> {"scene"=> {"scene_id"=> 123}}}
    else
      post_data = {"action_name"=> "QR_LIMIT_SCENE", "action_info" => {"scene" => {"scene_id"=> 123}}}
    end

    res = RestClient::post(url,post_data.to_json)
    ret = JSON.parse(res.body)
    p "generate_temporary_qr #{ret}"
    qr_code = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{ret["ticket"]}"
  end


end