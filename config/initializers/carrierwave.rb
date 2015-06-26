::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "gBlgwMtgrEBgCTpjfXobrI9JN9JJEgqnrgqjGr-3"
  config.qiniu_secret_key    = "gVkfU39Juj8Qynu7zrh8R9VMg-pv7k_MyR3JmQkq"
  config.qiniu_bucket        = "carrierwave-qiniu-example"
  config.qiniu_bucket_domain = "carrierwave-qiniu-example.aspxboy.com"
  config.qiniu_bucket_private= true #default is false
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = "http"
end