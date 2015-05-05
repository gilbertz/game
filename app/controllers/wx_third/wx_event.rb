require File.expand_path('../wx_util',__FILE__)
class WxEvent

  class << self
    # 处理第三放的事件消息
    def deal_event_msg(appid,event_msg)
      # 发送给某个公众账号的---微信号
      to_user_name = event_msg["ToUserName"]
      # 普通微信用户的open id
      from_user_name = event_msg["FromUserName"]
      event = event_msg["Event"]
      create_time = event_msg["CreateTime"].to_s
      p "from_user_name = #{from_user_name}  create_time = #{create_time}"
      #判重处理
#      if UniqueKeyUtil.exitsUnique?("#{from_user_name}#{create_time}") == true
	p "uniqueKeyUtil exit"      
	#return
 #     end
  #    UniqueKeyUtil.setUnique("#{from_user_name}#{create_time}")
     
     p "==================begin event============"

      begin
        # 用户领取了卡券
        if event == "user_get_card"
          deal_user_get_card(appid,event_msg)
        elsif event == "user_del_card"
          p "================deal_user_del_card"
          deal_user_del_card(appid,event_msg)
        elsif event == "user_comsume_card"
          deal_user_comsume_card(appid,event_msg)
        end
      rescue

      ensure
          UniqueKeyUtil.delUnique("#{from_user_name}#{create_time}")
      end

    end

    #卡券审核通过
    def deal_card_pass_check(appid,event_msg)
      card_id = event_msg["CardId"]
      WxUtil.save_card_info(appid,card_id)
    end
    #卡券审核未通过
    def deal_card_not_pass_check(appid,event_msg)
      card_id = event_msg["CardId"]
      WxUtil.save_card_info(appid,card_id)
    end

    #用户领取了卡券事件
    def deal_user_get_card(appid, event_msg)
      WxUtil.save_card_record(appid,event_msg)
    end

    #用户删除了卡券事件
    def deal_user_del_card(appid, event_msg)
      WxUtil.save_card_record(appid,event_msg)
    end

    #用户使用了卡券事件 －－－》 核销
    def deal_user_comsume_card(appid, event_msg)
      WxUtil.save_card_record(appid,event_msg)
    end


  end

end
