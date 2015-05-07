require File.expand_path('../wx_util',__FILE__)
class WxMessage

  class << self

    # 处理第三方的文本消息--->未开发
    def deal_text_msg(appid,text_msg)
      # 发送给某个公众账号的---微信号
      to_user_name = event_msg["ToUserName"]
      # 普通微信用户的open id
      from_user_name = event_msg["FromUserName"]
      content = "TESTCOMPONENT_MSG_TYPE_TEXT_callback"

    end


    # 发送文本消息
    # {
    #     "touser":"OPENID",
    #     "msgtype":"text",
    #     "text":
    #     {
    #        "content":"Hello World"
    #     }
    # }
    def send_text_custom(to_user, content)
      message = default_options(to_user).merge({text: {content: content}})
      http_post(custom_base_url, message)
    end

    # 发送图片消息
    # {
    #     "touser":"OPENID",
    #     "msgtype":"image",
    #     "image":
    #     {
    #       "media_id":"MEDIA_ID"
    #     }
    # }
    def send_image_custom(to_user, media_id)
      message = default_options(to_user, "image").merge({image: {media_id: media_id}})
      http_post(custom_base_url, message)
    end

    # 发送语音消息
    # {
    #     "touser":"OPENID",
    #     "msgtype":"voice",
    #     "voice":
    #     {
    #       "media_id":"MEDIA_ID"
    #     }
    # }
    def send_voice_custom(to_user, media_id)
      message = default_options(to_user, "voice").merge({voice: {media_id: media_id}})
      http_post(custom_base_url, message)
    end

    # 发送视频消息
    # {
    #     "touser":"OPENID",
    #     "msgtype":"video",
    #     "video":
    #     {
    #       "media_id":"MEDIA_ID"
    #     }
    # }
    def send_video_custom(to_user, media_id, options={})
      video_options = {media_id: media_id}.merge(options)
      message = default_options(to_user, "video").merge({video: video_options})
      http_post(custom_base_url, message)
    end

    # 发送音乐消息
    # {
    #     "touser":"OPENID",
    #     "msgtype":"music",
    #     "music":
    #     {
    #      "title":"MUSIC_TITLE",
    #     "description":"MUSIC_DESCRIPTION",
    #      "musicurl":"MUSIC_URL",
    #     "hqmusicurl":"HQ_MUSIC_URL",
    #      "thumb_media_id":"THUMB_MEDIA_ID"
    #     }
    # }
    def send_music_custom(to_user, media_id, musicurl, hqmusicurl, options={})
      music_options = { thumb_media_id: media_id,
                        musicurl: musicurl,
                        hqmusicurl: hqmusicurl
      }.merge(options)
      message = default_options(to_user, "music").merge({music: music_options})
      http_post(custom_base_url, message)
    end

    # 发送图文消息
    # {
    #     "touser":"OPENID",
    #     "msgtype":"news",
    #      "news":{
    #        "articles": [
    #         {
    #             "title":"Happy Day",
    #             "description":"Is Really A Happy Day",
    #             "url":"URL",
    #             "picurl":"PIC_URL"
    #         },
    #         {
    #             "title":"Happy Day",
    #             "description":"Is Really A Happy Day",
    #             "url":"URL",
    #             "picurl":"PIC_URL"
    #         }
    #         ]
    #    }
    # }
    def send_news_custom(to_user, articles=[])
      message = default_options(to_user, "news").merge({news: {articles: articles}})
      http_post(custom_base_url, message)
    end

    private

    # https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=ACCESS_TOKEN
    def custom_base_url
      "/message/custom/send"
    end

    def default_options(to_user, msgtype="text")
      {touser: to_user, msgtype: msgtype}
    end

  end

end