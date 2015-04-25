require File.expand_path('../wx_error_code',__FILE__)
require File.expand_path('../wxsha1',__FILE__)
require File.expand_path('../wxxml_parse',__FILE__)
require File.expand_path('../wxpkcs7_encoder',__FILE__)
require File.expand_path('../aes_tool',__FILE__)


class WXBizMsgCrypt
   # /**
	 # * 构造函数
	 # * @param $token string 公众平台上，开发者设置的token
	 # * @param $encodingAesKey string 公众平台上，开发者设置的EncodingAESKey
	 # * @param $appId string 公众平台的appId
	 # */
  def initialize(appId,token, encodingAesKey)
      @token = token
      @encodingAesKey = encodingAesKey
      @appId = appId
  end

  # /**
	 # * 对明文进行加密.
	 # *
	 # * @param text 需要加密的明文
	 # * @return 加密后base64编码的字符串
	 # * @throws AesException aes加密失败
	 # */
  def encryptMsg(text)
   begin
     aesKey = Base64.decode(@encodingAesKey+"=")


   rescue
     return nil
   end

  end

   # /**
	 # * 对密文进行解密.
	 # *
	 # * @param text 需要解密的密文
	 # * @return 解密得到的明文
	 # * @throws AesException aes解密失败
	 # */
  def  decryptMsg(text)
    if @encodingAesKey.length != 43
      return nil
    end

    begin
      aesKey = Base64.decode(@encodingAesKey+"=")
      aes_msg = Base64.decode(postData)
      #AES 解密
      iv = aesKey[0,16]
      rand_msg = AesTool.aes256_cbc_decrypt(aesKey,text,iv)


    rescue
      return nil
    end


  end



  # // 生成4个字节的网络字节序
  def getNetworkBytesOrder(sourceNumber)
    orderBytes = Array.new
    orderBytes[3] = (sourceNumber & 0xFF)
    orderBytes[2] = (sourceNumber >> 8 & 0xFF)
    orderBytes[1] = (sourceNumber >> 16 & 0xFF)
    orderBytes[0] = (sourceNumber >> 24 & 0xFF)
    return orderBytes
  end

  # // 还原4个字节的网络字节序
  def recoverNetworkBytesOrder(orderBytes)
    int sourceNumber = 0;
    for i in 0...4
      sourceNumber <<= 8;
      sourceNumber |= orderBytes[i] & 0xff;
    end
    return sourceNumber
  end

  # /**
  # * 随机生成16位字符串
  # * @return string 生成的字符串
  # */
  def getRandomStr(len=16)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newStr = ""
    1.upto(len) { |i| newStr << chars[rand(chars.size-1)] }
    return newStr
  end

end