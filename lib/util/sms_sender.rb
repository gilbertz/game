class SmsSender

  class << self
    def send_to(mobile)
      code = sprintf("%04d",rand(9999))
      $redis.set sms_code_key(mobile), code
      $redis.expire(sms_code_key(mobile), 60)
      ChinaSMS.to(mobile, "注册验证码:#{code} 【#{$app_name}】")
    end

    def sms_code_key(mobile)
      "#{mobile}_sms_code"
    end

  end

end