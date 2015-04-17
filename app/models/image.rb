# encoding: utf-8
class Image < ActiveRecord::Base
  belongs_to :category, class_name: "Category", polymorphic: true 
  belongs_to :viewable, class_name: "Material", polymorphic: true  
  belongs_to :user

  STATE = {
    0  => "无",
    1  => "背景",
    2  => "页面",
    3  => "提示",
    4  => "输入",
    5  => "返回背景",
    6  => "返回页面",
    7  => "返回按钮",
    8  => "分享按钮", 
    9  => "提交按钮",
    10 => "背景2",
    11 => "背景3",
    12 => "背景4",
    13 => "页面2",
    14 => "页面3",
    15 => "页面4",  
    16 => "关闭按钮"
  }

  def cn_state 
    STATE[self.state] 
  end


  def beacon_name
    if self.beaconid
      b = Ibeacon.find_by_id self.beaconid
      if b
        return b.name
      end
    end
  end

  def user_name
    if self.user
      self.user.name
    end
  end

  def app_name
  end

  def get_url
    self.body
  end
    

end
