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
    if not self.photo_path.blank? and not self.photo_name.blank?
      #self.photo_path + self.photo_name
      "http://wx.51self.com/uploads/sucai/" + self.photo_name
    else
      self.body
    end
  end
    

  def self.build(user_id, image_data, image_type, file_data=nil)
    m = Image.new
    m.user_id = user_id

    unless file_data
      file_type = image_type
      bi_image=Base64::decode64( image_data )
    else
      file_type  = file_data.original_filename.split(".").last
      bi_image = file_data.read
    end

    photo_path = "/data/www/game/public/uploads/sucai/"
    new_str = Time.now.to_i.to_s + ((100..999).to_a.shuffle[0].to_s)
    #if file_type == "jpg" or file_type == "png"
    if true
      photo_file_name = new_str + "." + file_type
      photo_file = photo_path + photo_file_name
      File.open(photo_file, "wb") { |f| f.write( bi_image ) }
      m.photo_path = photo_path
      m.photo_name = photo_file_name
      m.save
      return
    end
 end


end
