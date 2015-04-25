require 'openssl'
require 'digest'
class AesTool

  def self.aes128_cbc_encrypt(key, data, iv)
    key = Digest::MD5.digest(key) if(key.kind_of?(String) && 16 != key.bytesize)
    iv = Digest::MD5.digest(iv) if(iv.kind_of?(String) && 16 != iv.bytesize)
    aes = OpenSSL::Cipher.new('AES-128-CBC')
    aes.encrypt
    aes.key = key
    aes.iv = iv
    aes.update(data) + aes.final
  end

  def self.aes256_cbc_encrypt(key, data, iv)
    key = Digest::SHA256.digest(key) if(key.kind_of?(String) && 32 != key.bytesize)
    iv = Digest::MD5.digest(iv) if(iv.kind_of?(String) && 16 != iv.bytesize)
    aes = OpenSSL::Cipher.new('AES-256-CBC')
    aes.encrypt
    aes.key = key
    aes.iv = iv
    aes.update(data) + aes.final
  end

  def self.aes128_cbc_decrypt(key, data, iv)
    key = Digest::MD5.digest(key) if(key.kind_of?(String) && 16 != key.bytesize)
    iv = Digest::MD5.digest(iv) if(iv.kind_of?(String) && 16 != iv.bytesize)
    aes = OpenSSL::Cipher.new('AES-128-CBC')
    aes.decrypt
    aes.key = key
    aes.iv = iv
    aes.update(data) + aes.final
  end

  def self.aes256_cbc_decrypt(key, data, iv)
    key = Digest::SHA256.digest(key) if(key.kind_of?(String) && 32 != key.bytesize)
    iv = Digest::MD5.digest(iv) if(iv.kind_of?(String) && 16 != iv.bytesize)
    aes = OpenSSL::Cipher.new('AES-256-CBC')
    aes.decrypt
    aes.key = key
    aes.iv = iv
    aes.update(data) + aes.final
  end

end