require 'rexml/document'

# /**
#  * XMLParse class
#  *
#  * 提供提取消息格式中的密文及生成回复消息格式的接口.
#  */
class WXXMLParse

   # /**
	 # * 提取出xml数据包中的加密消息
	 # * @param string $xmltext 待提取的xml字符串
	 # * @return string 提取出的加密消息字符串
	 # */
  def self.extract(xmltext)
    begin

    end

  end

   # /**
	 # * 生成xml消息
	 # * @param encrypt 加密后的消息密文
	 # * @param signature 安全签名
	 # * @param timestamp 时间戳
	 # * @param nonce 随机字符串
	 # * @return 生成的xml字符串
	 # */
  def self.generate(encrypt,signature,timestamp,nonce)
   format = "<xml>\n" + "<Encrypt><![CDATA[#{encrypt}]]></Encrypt>\n"
   format +=  "<MsgSignature><![CDATA[#{signature}]]></MsgSignature>\n";
   format += "<TimeStamp>#{timestamp}</TimeStamp>\n" + "<Nonce><![CDATA[#{nonce}]]></Nonce>\n" + "</xml>";

    return format
  end
end