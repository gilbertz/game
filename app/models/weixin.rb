class Weixin < ActiveRecord::Base
  def pv
    key = "wx_#{self.id}"
    $redis.get(key)
  end
end
