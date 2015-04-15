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
     end
  end

    def array_xml
      doc = Document.new"<somedata/>"
      root_node = doc.root
      el1 = root_node.add_element "sign"
      el1.text = ""
      el2 = root_node.add_element "mch_billno"
      el2.text = ""
      el3 = root_node.add_element "mch_id"
      el3.text = ""
      el4 = root_node.add_element "wxappid"
      el4.text = ""
      el5 = root_node.add_element "nick_name"
      el5.text = ""
      el6 = root_node.add_element "send_name"
      el6.text = ""
      el7 = root_node.add_element "re_openid"
      el7.text = ""
      el8 = root_node.add_element "total_amount"
      el8.text = ""
      el9 = root_node.add_element "min_value"
      el10 = root_node.add_element "max_value"
      el11 = root_node.add_element "total_num"
      el12 = root_node.add_element "wishing"
      el12.text = Redpack.find_by(beaconid: beaconid).wishing
      el13 = root_node.add_element "client_ip"
      el14 = root_node.add_element "act_name"
      el15 = root_node.add_element "act_id"
      el16 = root_node.add_element "remark"
      el17 = root_node.add_element "logo_imgurl"
      el18 = root_node.add_element "share_content"
      el19 = root_node.add_element "share_url"
      el20 = root_node.add_element "share_imgurl"
      el21 = root_node.add_element "nonce_str"
      return doc.to_s
    end

end
