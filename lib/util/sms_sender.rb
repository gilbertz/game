class SmsSender

  class << self
    def send_to(mobile)
      code = sprintf("%04d",rand(9999))
      $redis.set sms_code_key(mobile), code
      $redis.expire(sms_code_key(mobile), 600)
      ChinaSMS.to(mobile, "尊敬的用户,您好!感谢您使用我们的服务,当前验证码为:#{code},请在10分钟内按提示提交验证码农 【#{$app_name}】")
    end

    def sms_code_key(mobile)
      "#{mobile}_sms_code"
    end

    def sms_code(mobile)
      $redis.get(sms_code_key(mobile))
    end

  end

end