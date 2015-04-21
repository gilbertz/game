#微信第三方公众平台错误码
#
class WXErrorCode
  @@OK = 0;
  @@ValidateSignatureError = -40001;
  @@ParseXmlError = -40002;
  @@ComputeSignatureError = -40003;
  @@IllegalAesKey = -40004;
  @@ValidateAppidError = -40005;
  @@EncryptAESError = -40006;
  @@DecryptAESError = -40007;
  @@IllegalBuffer = -40008;
  @@EncodeBase64Error = -40009;
  @@DecodeBase64Error = -40010;
  @@GenReturnXmlError = -40011;

  def self.OK
    return @@OK;
  end

  def self.ValidateSignatureError
    return @@ValidateSignatureError;
  end


  def self.ParseXmlError
    return @@ParseXmlError;
  end


  def self.ComputeSignatureError
    return @@ComputeSignatureError;
  end

  def self.IllegalAesKey
    return @@IllegalAesKey;
  end

  def self.ValidateAppidError
    return @@ValidateAppidError;
  end

  def self.EncryptAESError
    return @@EncryptAESError;
  end

  def self.DecryptAESError
    return @@DecryptAESError;
  end

  def self.IllegalBuffer
    return @@IllegalBuffer;
  end

  def self.EncodeBase64Error
    return @@EncodeBase64Error;
  end

  def self.EncodeBase64Error
    return @@EncodeBase64Error;
  end


  def self.DecodeBase64Error
    return @@DecodeBase64Error;
  end

  def self.GenReturnXmlError
    return @@GenReturnXmlError;
  end

end