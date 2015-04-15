class Redpack < ActiveRecord::Base
  require 'net/https'
  require 'uri'
  require 'rexml/document'
  include REXML

  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def do_red_pack_request
    weixin_post
    return 
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

     request.body = array_xml
     response = http.start do |http|
     ret = http.request(request)
     puts request.body
     puts ret.body
     doc = Document.new(ret.body)
     chapter1 = doc.root.elements[8] #输出节点中的子节点
     puts chapter1.text #输出第一个节点的包含文本
     return chapter1.text
     end
  end

    def array_xml
      doc = Document.new"<xml/>"
      root_node = doc.root
      el14 = root_node.add_element "act_name"
      el14.text = '1'
      el13 = root_node.add_element "client_ip"
      el13.text = '121.42.47.121'
      el10 = root_node.add_element "max_value"
      el10.text = '100' 
      el2 = root_node.add_element "mch_billno"
      el2.text = '1233034702'+Time.new.strftime("%Y%d%m").to_s+rand(9999999999).to_s
      el3 = root_node.add_element "mch_id"
      el3.text = '1233034702'
      el9 = root_node.add_element "min_value"
      el9.text = '100'
      el5 = root_node.add_element "nick_name"
      el5.text = "1"
      el21 = root_node.add_element "nonce_str"
      el21.text = Digest::MD5.hexdigest(rand(999999).to_s).to_s
      el22 = root_node.add_element "re_openid"
      el22.text = current_user.get_openid
      el16 = root_node.add_element "remark"
      el16.text = '1'
      el6 = root_node.add_element "send_name"
      el6.text = "2"
      el8 = root_node.add_element "total_amount"
      el8.text = "100"
      el11 = root_node.add_element "total_num"
      el11.text = '1'
      el12 = root_node.add_element "wishing"
      el12.text = "1"
      el4 = root_node.add_element "wxappid"
      el4.text = 'wx456ffb04ee140d84'
      # el15 = root_node.add_element "act_id"
      # el15.text = "1"
      # el17 = root_node.add_element "logo_imgurl"
      # el18 = root_node.add_element "share_content"
      # el19 = root_node.add_element "share_url"
      # el20 = root_node.add_element "share_imgurl"
      stringA="act_name="+el14.text.to_s+"&client_ip="+el13.text.to_s+"&max_value="+el10.text.to_s+"&mch_billno="+el2.text.to_s+"&mch_id="+el3.text.to_s+"&min_value="+el9.text.to_s+"&nick_name="+el5.text.to_s+"&nonce_str="+el21.text.to_s+"&re_openid="+el22.text.to_s+"&remark="+el16.text.to_s+"&send_name="+el6.text.to_s+"&total_amount="+el8.text.to_s+"&total_num="+el11.text.to_s+"&wishing="+el12.text.to_s+"&wxappid="+el4.text.to_s
      stringSignTemp=stringA+"&key=wangpeisheng1234567890leapcliffW"
      puts stringSignTemp
      sign=Digest::MD5.hexdigest(stringSignTemp).upcase
      el1 = root_node.add_element "sign"
      el1.text = sign

      return doc.to_s
    end

end
