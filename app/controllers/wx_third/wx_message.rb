class WxMessage

  class << self

    # 处理第三方的文本消息--->未开发
    def deal_text_msg(appid,text_msg)
      # 发送给某个公众账号的---微信号
      to_user_name = event_msg["ToUserName"]
      # 普通微信用户的open id
      from_user_name = event_msg["FromUserName"]
      content = "TESTCOMPONENT_MSG_TYPE_TEXT_callback"

    end


  end

end