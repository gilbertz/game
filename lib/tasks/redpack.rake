
require File.expand_path('../../../config/initializers/redis',__FILE__)
#require File.expand_path('../../../config/environments/development',__FILE__)
require File.expand_path('../../../config/environments/production',__FILE__)
require File.expand_path('../../../config/initializers/weixin',__FILE__)


namespace :redpack do

  desc "生成红包"
  task :generate_redpack,[:total,:count,:max,:min] do |t,args|

     puts 'generate_redpack'
     Redpack.generate(args[:total],args[:count],args[:max],args[:min])


  end


  desc "通知抢红包"
  task :notice_redpack_begin do

    puts 'notice_redpack_begin'
    $wxclient.send_text_custom("oRKD0s8stWW-DUiWIKDKV22qaUVI","1245wwwwww")
    data = {first:{value:"您好,你参加的德高巴士抢红包活动即将开始",color:"#173177"},keyword1:{value:"chentao",color:"#173177"},keyword2:{value:"德高巴士抢红包,爱上摇一摇",color:"#173177"},keyword3:{value:"马上开始",color:"#173177"},keyword4:{value:"此时此地",color:"#173177"}}
    $wxclient1.send_template_msg("oNnqbt_LiqkMXMrzHEawO-G9r8Vo", "hMQm4-BGvNX-XIRQnfb_MG3EP6AFCDEFJ0gPrBX7oeg", "http://www.dapeimishu.com/", "#FF0000", data)

    checks = Check.find(:conditions=>"state = 1")
    if checks
      checks.each do |check|



      end


    end



  end

end