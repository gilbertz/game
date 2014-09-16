class Weixin < ActiveRecord::Base
  def pv
    key = "weixin_#{self.id}"
    $redis.get(key)
  end
end
