

# 微信第三方平台
# 摇一摇
# SHAKE_TOKEN = "shake"
# SHAKE_APPID = "wxf04f335ad44b01cc"
# SHAKE_APPSECRET = "0c79e1fa963cd80cc0be99b20a18faeb"
# SHAKE_ENCODKEY = "abcdefgh1234567890abcdefgh123456789abcdefgh"
#  SHAKE_DOMAIN = "http://j.51self.com"


# 疯狂摇一摇
# SHAKE_TOKEN = "shake"
# SHAKE_APPID = "wx6033a12fd291dd3d"
# SHAKE_APPSECRET = "0c79e1fa963cd80cc0be99b20a18faeb"
# SHAKE_ENCODKEY = "abcdefgh1234567890abcdefgh123456789abcdefgh"
# SHAKE_DOMAIN = "http://i.51self.com"

if Rails.env.development?
  #搭配秘书
  SHAKE_TOKEN = "shake"
  SHAKE_APPID = "wx6bfb1f6696fb34aa"
  SHAKE_APPSECRET = "0c79e1fa963cd80cc0be99b20a18faeb"
  SHAKE_ENCODKEY = "abcdefgh1234567890abcdefgh123456789abcdefgh"
  SHAKE_DOMAIN = "http://dapeimishu.com"


  WX_DOMAIN = 'dapeimishu.com'
  WX_APPID = 'wx629a5ad4f3fc5f63'
  WX_SECRET= '843d5cb0b87561e54c644327bd297f10'

else
  #摇生意
  SHAKE_TOKEN = "shake"
  SHAKE_APPID = "wxc7765ff7bcb38464"
  SHAKE_APPSECRET = "0c79e1fa963cd80cc0be99b20a18faeb"
  SHAKE_ENCODKEY = "abcdefgh1234567890abcdefgh123456789abcdefgh"
  SHAKE_DOMAIN = "http://wx.yaoshengyi.com"


  WX_DOMAIN = 'wx.yaoshengyi.com'
  WX_APPID = 'wx456ffb04ee140d84'
  WX_SECRET= 'd1481d1ff0f05d0234a391cfc1c2a4b3'

end



$wxclient ||= WeixinAuthorize::Client.new(WX_APPID, WX_SECRET)
$wxclient1 ||= WeixinAuthorize::Client.new('wx456ffb04ee140d84', 'd1481d1ff0f05d0234a391cfc1c2a4b3')


# 搭配秘书网站应用
WEB_APPID = "wx9d0f1c5f64702271"
WEB_APPSECRET = "8b7735574eca7c9a951c324070c4f1fc"
WEB_DOMAIN = "http://www.dapeimishu.com"

# 微信发红包金额限制
WEIXIN_REDPACK_RESTRICTION_VALUE = 100