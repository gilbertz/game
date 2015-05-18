class Check < ActiveRecord::Base
  belongs_to :user
  belongs_to :ibeacon
  
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

  def self.check_per_day(user_id,game_id)
     Check.where("user_id = ? and game_id = ? and created_at >= ? and created_at <= ?" , user_id, game_id, Date.today.beginning_of_day, Date.today.end_of_day).length
  end

  def self.check_today(user_id)
     Check.find_by("user_id = ? and state = ? and created_at >= ? and created_at <= ?", user_id, 1, Date.today.beginning_of_day,Date.today.end_of_day)
  end
  def self.check_three(user_id,game_id)
      if a = Check.where("user_id = ? and game_id = ? and created_at >= ? and created_at <= ?" , user_id, game_id, Date.today.beginning_of_day, Date.today.end_of_day)
        a.length
      end
  end
end
