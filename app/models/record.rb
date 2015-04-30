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
  
  def self.redpack_per_day(user_id, game_id)
    Record.where("user_id = ? and game_id = ? and created_at >= ? and created_at < ?", user_id, game_id, Date.today.beginning_of_day, Date.today.end_of_day).length
  end
end
