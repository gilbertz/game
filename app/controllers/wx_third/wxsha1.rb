require File.expand_path('../wx_error_code',__FILE__)
require 'digest/sha2'
# /**
#  * SHA1 class
#  *
#  * 计算公众平台的消息签名接口.
#  */
class WXSHA1
   # /**
	 # * 用SHA1算法生成安全签名
	 # * @param string $token 票据
	 # * @param string $timestamp 时间戳
	 # * @param string $nonce 随机字符串
	 # * @param string $encrypt 密文消息
	 # */
  def self.getSHA1(token,timestamp,nonce,encrypt_msg)
    begin
      array = [token,timestamp,nonce,encrypt_msg]
      array.sort!()
      str = array.join()
      # 用拼接好的字符串进行 sha1加密f
      shaStr = Digest::SHA1.hexdigest(str)
      return shaStr
    rescue
        return nil
    end
  end
  getSHA1("1","ew","24","efwfw");

end
