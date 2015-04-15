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
     chapter1 = doc.root.elements[5] #输出节点中的子节点
     puts chapter1.text #输出第一个节点的包含文本
     return chapter1.text
     end
  end

    def array_xml
      doc = Document.new"<somedata/>"
      root_node = doc.root
      stringA="appid=wxd930ea5d5a258f4f&body=test&device_info=1000&mch_id=1233034702&nonce_str=ibuaiVcKdpRxkhJA";
      stringSignTemp="stringA"+"&key=192006250b4c09247ec02edce69f6a2d"
      sign=Digest::MD5.hexdigest(stringSignTemp).upcase
      el1 = root_node.add_element "sign"
      el1.text = sign
      el2 = root_node.add_element "mch_billno"
      el2.text = '1233034702'+Time.new.strftime("%Y%d%m").to_s+rand(9999999999).to_s
      el3 = root_node.add_element "mch_id"
      el3.text = '1233034702'
      el4 = root_node.add_element "wxappid"
      el4.text = 'wx456ffb04ee140d84'
      el5 = root_node.add_element "nick_name"
      el5.text = "疯狂摇一摇"
      el6 = root_node.add_element "send_name"
      el6.text = Redpack.find_by(1).sender_name
      el7 = root_node.add_element "re_openid"
      el7.text = "oNnqbt0tR5uMo8LNVM0_8upfRkeo"
      el8 = root_node.add_element "total_amount"
      el8.text = "100"
      el9 = root_node.add_element "min_value"
      el9.text = '100'
      el10 = root_node.add_element "max_value"
      el10.text = '100' 
      el11 = root_node.add_element "total_num"
      el11.text = '1'
      el12 = root_node.add_element "wishing"
      el12.text = Redpack.find_by(1).wishing
      el13 = root_node.add_element "client_ip"
      el13.text = '121.42.47.121'
      el14 = root_node.add_element "act_name"
      el14.text = '驯鹿之旅送红包！'
      el15 = root_node.add_element "act_id"
      el15.text = ""
      el16 = root_node.add_element "remark"
      el16.text = '关注驯鹿之旅，红包多多！'
      el17 = root_node.add_element "logo_imgurl"
      el18 = root_node.add_element "share_content"
      el19 = root_node.add_element "share_url"
      el20 = root_node.add_element "share_imgurl"
      el21 = root_node.add_element "nonce_str"
      el21.text = Digest::MD5.hexdigest(rand(999999).to_s).to_s
      return doc.to_s
    end

end
