class Score < ActiveRecord::Base
  belongs_to :user
  
  
  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def user_name
    self.user.name
  end

  def app_name
    if self.game_id
      m = Material.find_by_id self.game_id
      if m
        return m.name
      end
    end
  end


  def self.jifen(b, u)
    ss = Score.where(:beaconid=>b.id, :user_id=>u.id)
    ss.sum{|s|s.value}
  end

  def self.rank(b, u)
    
  end

end
