class Wshow < ActiveRecord::Base
  def pv
    key = "wshow_pv_#{self.id}"
    $redis.get(key)
  end

  def share_count(type)
     key = "wx_wshow_#{type}_#{self.url}"
     $redis.get(key)
  end
  
  def invert_state
    val = state.eql?(0) ? 1 : 0
    self.update_attributes(state: val)
  end

  def cn_state; { 0 => '下线', 1 => '上线', nil => '下线' }[state] end

end
