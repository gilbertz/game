class Redpack < ActiveRecord::Base
  require 'net/https'
  require 'uri'

  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def weixin_post
    uri = URI.parse('https://api.mch.weixin.qq.com/mmpaymkttransfers/sendredpack')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
    http.cert =OpenSSL::X509::Certificate.new(File.read("weixin_pay/cert/apiclient_cert.pem"))
    http.key =OpenSSL::PKey::RSA.new(File.read("weixin_pay/cert/apiclient_key.pem"), '1229344702')# key and password
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE #这个也很重要

    request = Net::HTTP::Post.new(uri)
    request.content_type = 'text/xml'
    request.body = "<?xml version='1.0' encoding='UTF-8'?><somedata><sign>C380BEC2BFD727A4B6845133519F3AD6</sign><mch_billno>10000098201411111234567890</mch_billno><mch_id>10000098</mch_id><wxappid>wx8888888888888888</wxappid><nick_name>天虹百货</nick_name><send_name>天虹百货</send_name><re_openid>oxTWIuGaIt6gTKsQRLau2M0yL16E</re_openid><total_amount>100</total_amount><min_value>100</min_value><max_value>100</max_value><total_num>1</total_num><wishing>感谢您参加猜灯谜活动，祝您元宵节快乐</wishing><client_ip>192.168.0.1</client_ip><act_name>猜灯谜抢红包活动</act_name><act_id></act_id><remark>猜越多得越多，快来抢！</remark><logo_imgurl></logo_imgurl><share_content></share_content><share_url></share_url><share_imgurl></share_imgurl><nonce_str>5K8264ILTKCH16CQ2502SI8ZNMTM67VS</nonce_str></somedata>"
     response = http.start do |http|
     ret = http.request(request)
     puts request.body
     puts ret.body
     end
  end
end
