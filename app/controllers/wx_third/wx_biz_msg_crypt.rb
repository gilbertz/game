require File.expand_path('../wx_error_code',__FILE__)
require File.expand_path('../wxsha1',__FILE__)
require File.expand_path('../WXXMLParse',__FILE__)
require File.expand_path('../WXPKCS7Encoder',__FILE__)

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
	 # * 将公众平台回复用户的消息加密打包.
	 # * <ol>
	 # *    <li>对要发送的消息进行AES-CBC加密</li>
  # *    <li>生成安全签名</li>
	 # *    <li>将消息密文和安全签名打包成xml格式</li>
  # * </ol>
	 # *
	 # * @param $replyMsg string 公众平台待回复用户的消息，xml格式的字符串
	 # * @param $timeStamp string 时间戳，可以自己生成，也可以用URL参数的timestamp
	 # * @param $nonce string 随机串，可以自己生成，也可以用URL参数的nonce
	 # * @param &$encryptMsg string 加密后的可以直接回复用户的密文，包括msg_signature, timestamp, nonce, encrypt的xml格式的字符串,
	 # *                      当return返回0时有效
	 # *
	 # * @return int 成功0，失败返回对应的错误码
	 # */
  def encryptMsg(replyMsg, timeStamp, nonce)


  end



  # /**
	 # * 检验消息的真实性，并且获取解密后的明文.
	 # * <ol>
	 # *    <li>利用收到的密文生成安全签名，进行签名验证</li>
  # *    <li>若验证通过，则提取xml中的加密消息</li>
	 # *    <li>对消息进行解密</li>
  # * </ol>
	 # *
	 # * @param $msgSignature string 签名串，对应URL参数的msg_signature
	 # * @param $timestamp string 时间戳 对应URL参数的timestamp
	 # * @param $nonce string 随机串，对应URL参数的nonce
	 # * @param $postData string 密文，对应POST请求的数据
	 # * @param &$msg string 解密后的原文，当return返回0时有效
	 # *
	 # * @return int 成功0，失败返回对应的错误码
	 # */
  def  decryptMsg(msgSignature, timestamp, nonce, postData)
    if @encodingAesKey.length != 43
      return WXErrorCode.IllegalAesKey
    end

    pc = WXPrpcrypt

  end

end