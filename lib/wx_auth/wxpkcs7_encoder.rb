#require './wx_error_code'

# /**
# * PKCS7Encoder class
# *
# * 提供基于PKCS7算法的加解密接口.
# */
class WXPKCS7Encoder

  @@block_size = 70

   # /**
	 # * 对需要加密的明文进行填充补位
	 # * @param $text 需要进行填充补位操作的明文
	 # * @return 补齐明文字符串
	 # */
  def self.encode(text)
    text_length = text.length
    #计算需要填充的位数
    amount_to_pay = @@block_size - (text_length % @@block_size)
    puts "amount:#{amount_to_pay}"
    if amount_to_pay == 0
      amount_to_pay = @@block_size
    end
    #获得补位所用的字符
    pad_chr = amount_to_pay.chr
    puts 65.chr
    puts "pad_chr:#{pad_chr}"
    tmp = ""
    for i in 0...amount_to_pay
      tmp << pad_chr.to_s
    end
    puts "tmp #{tmp}"
    return text<<tmp

  end

   # /**
	 # * 对解密后的明文进行补位删除
	 # * @param decrypted 解密后的明文
	 # * @return 删除填充补位后的明文
	 # */
  def self.decode(text)
    pad = text[-1].ord
    if pad < 1 || pad > @@block_size
      pad = 0
    end

    return text[0,text.length - pad];
  end


  puts encode("xxx32")

  puts decode(encode("xxx32"))
end


# /**
#  * Prpcrypt class
#  *
#  * 提供接收和推送给公众平台消息的加解密接口.
#  */
class WXPrpcrypt
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
