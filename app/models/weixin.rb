class Weixin < ActiveRecord::Base
  def pv
    key = "wx_id_#{self.wxid}"
    $redis.get(key)
  end
end
