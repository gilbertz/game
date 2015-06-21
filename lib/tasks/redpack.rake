namespace :redpack do
  desc "补发红包"
  task :resend => :environment do

    puts 'resend_redpack'
    rs = Record.where('score >= 9500').order('created_at desc').limit(1000)
    rs.each do |r|
     u = User.find_by_id r.from_user_id
     u.resend_redpack(r.game_id, r.beaconid) if u
    end

  end


  desc "生成红包"
  task :generate_redpack => :environment do
 
    puts 'generate_redpack'
     
    redpack_time = RedpackTime.get_redpack_time(5) 
    min = redpack_time.min
    max = redpack_time.max

    amount = TimeAmount.get_amount(5,'dgbs')
    if amount != nil
      total = amount
      count = amount/200
      Redpack.generate(total,count,max,min, 5)
    end
  end

  desc "生成地推红包"
  task :generate_ditui_redpack => :environment do
 
    puts 'generate_ditui_redpack'
     
    redpack_time = RedpackTime.get_redpack_time(12) 
    min = redpack_time.min
    max = redpack_time.max

    amount = 300000
    if amount != nil
      total = amount
      count = amount/200
      Redpack.generate(total,count,max,min,12)
    end
  end

  desc "生成测试红包"

  task :generate_test_redpack => :environment do
 
     puts 'generate_redpack'
     
    redpack_time = RedpackTime.get_redpack_time(5) 
    min = redpack_time.min
    max = redpack_time.max
    redpack_time.update(:remain => 1)

    amount = 2000000
      if amount != nil
      total = amount
      count = amount/200
      Redpack.generate(total,count,max,min,5)
    end
  end


  desc "通知抢红包"
  task :notice_redpack_begin => :environment do
    checks = Check.find_by_sql("select * from checks where state = 1 and beaconid in (select id from ibeacons where name = '德高巴士')")
    if checks
      checks.each do |check|
        if check.state == 1 && (check.last_notice_time == nil || Time.now.to_i - check.last_notice_time.to_i > 20 * 3600)
          user = User.find_by_id(check.user_id)
          if user != nil
            authentication = Authentication.find_by_user_id(user.id)
            if authentication
              user_name = user.name
              data = {first:{value:"您好,你参加的德高巴士抢红包活动即将开始",color:"#173177"},keyword1:{value:user_name,color:"#173177"},keyword2:{value:"德高巴士抢红包,巴士摇一摇",color:"#173177"},keyword3:{value:"马上开始",color:"#173177"},keyword4:{value:"此时此地",color:"#173177"}}
              $wxclient1.send_template_msg(authentication.uid, "hMQm4-BGvNX-XIRQnfb_MG3EP6AFCDEFJ0gPrBX7oeg", "http://i.51self.com/dgbs/gs/1340208226", "#FF0000", data)
              check.last_notice_time = Time.now
              check.save
            end

          end

        end

      end

    end

  end

end
