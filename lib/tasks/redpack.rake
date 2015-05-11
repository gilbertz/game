namespace :redpack do

  desc "生成红包"
  task :generate_redpack,[:total,:count,:max,:min] do |t,args|

     puts 'generate_redpack'
     Redpack.generate(args[:total],args[:count],args[:max],args[:min])


  end


  desc "通知抢红包"
  task :notice_redpack_begin => :environment do

    puts 'notice_redpack_begin'
    $wxclient.send_text_custom("oRKD0s8stWW-DUiWIKDKV22qaUVI","1245wwwwww")

    ibeacon_arr = Ibeacon.find_all_by_name("德高巴士")
    ibeacon_ids = []
    ibeacon_arr.each do |ibeacon|
      ibeacon_ids.push(ibeacon.id)
    end

    checks = Check.find_by_sql("select * from checks where state = 1 ")
    if checks
      checks.each do |check|

        if check.state == 1 && (check.last_notice_time == nil || Time.now.to_i - check.last_notice_time.to_i > 20 * 3600)
          user = User.find(check.user_id)
          if user != nil
            user_name = user.name
            data = {first:{value:"您好,你参加的德高巴士抢红包活动即将开始",color:"#173177"},keyword1:{value:user_name,color:"#173177"},keyword2:{value:"德高巴士抢红包,爱上摇一摇",color:"#173177"},keyword3:{value:"马上开始",color:"#173177"},keyword4:{value:"此时此地",color:"#173177"}}
            $wxclient1.send_template_msg("oNnqbt_LiqkMXMrzHEawO-G9r8Vo", "hMQm4-BGvNX-XIRQnfb_MG3EP6AFCDEFJ0gPrBX7oeg", "http://www.dapeimishu.com/", "#FF0000", data)
            check.last_notice_time = Time.now
          end

        end

      end

    end

  end

end
