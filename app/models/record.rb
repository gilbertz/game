class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :material

  def self.record_statis(beacon_id,game_id,day)
    Record.where("created_at >= ? and created_at <= ? and beaconid = ? and game_id = ?",day.beginning_of_day,day.end_of_day,beacon_id,game_id)
  end

  def self.seed_redpack_num(beacon_id,game_id,day)
    item = "seed_redpack_num"
    unless $redis.exists("record_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Record.record_statis(beacon_id,game_id,day).as_json.select{|a| a["object_type"] == "Redpack"}.length
      $redis.set("record_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end
    return $redis.get("record_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def self.social_redpack_num(beacon_id,game_id,day)
    item = "social_redpack_num"
    unless $redis.exists("record_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Record.record_statis(beacon_id,game_id,day).as_json.select{|a| a["object_type"] == "social_redpack"}.length
      $redis.set("record_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end
    return $redis.get("record_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def self.feedback_redpack_num(beacon_id,game_id,day)
    item = "feedback_redpack_num"
    unless $redis.exists("record_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Record.record_statis(beacon_id,game_id,day).as_json.select{|a| a["object_type"] == "f_redpack"}.length
      $redis.set("record_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end
    return $redis.get("record_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def self.seed_redpack(beacon_id,game_id,day)
    item = "seed_redpack"
    unless $redis.exists("record_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Record.record_statis(beacon_id,game_id,day).as_json.select{|a| a["object_type"] == "Redpack"}.collect{|a| a["score"]}.reduce(:+)
      $redis.set("record_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end
    return $redis.get("record_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def self.social_redpack(beacon_id,game_id,day)
    item = "social_redpack"
    unless $redis.exists("record_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Record.record_statis(beacon_id,game_id,day).as_json.select{|a| a["object_type"] == "social_redpack"}.collect{|a| a["score"]}.reduce(:+)
      $redis.set("record_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end
    return $redis.get("record_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def self.feedback_redpack(beacon_id,game_id,day)
    item = "feedback_redpack"
    unless $redis.exists("record_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Record.record_statis(beacon_id,game_id,day).as_json.select{|a| a["object_type"] == "f_redpack"}.collect{|a| a["score"]}.reduce(:+)
      $redis.set("record_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end
    return $redis.get("record_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def beacon_name
    if self.beaconid
      b = Ibeacon.find_by_id self.beaconid
      if b
        return b.name
      end
    end
  end


  def get_beacon
    if self.beaconid
      Ibeacon.find_by_id self.beaconid
    end 
  end
  

  def get_game
    if self.game_id
       Material.find_by_id self.game_id
    end
  end


  def user_name
    if self.user
      self.user.name
    else
      ''
    end
  end


  def from_user_name
    if self.from_user_id
      fu = User.find_by_id(self.from_user_id)
      return fu.name if fu
    end
  end


  def user_img
    if self.user
      self.user.profile_img_url
    end
  end


  def app_name
    if self.game_id
      m = Material.find_by_id self.game_id
      if m
        return m.name
      end
    end
  end
  
  def self.redpack_per_day(user_id, game_id)
    Record.where("user_id = ? and game_id = ? and created_at >= ? and created_at < ?", user_id, game_id, Date.today.beginning_of_day, Date.today.end_of_day).length
  end

 
  def to_s
    remark = self.remark
    if remark.blank? and self.score.to_i > 0
      remark = "领到红包#{self.score.to_f/100}元"
    end
    self.user_name + remark 
  end
  
 
 def game_link
    self.get_game.get_link(self.get_beacon.url)
  end

  def get_qr_img
    'http://qr.liantu.com/api.php?text=' + self.game_link
  end


end
