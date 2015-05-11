class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :material


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
    self.user.name if self.user
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
