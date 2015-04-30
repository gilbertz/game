class Score < ActiveRecord::Base
  belongs_to :user

  after_create do
    self.user.update_user_score(self.beaconid)
  end

  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def user_name
    if self.user
      self.user.name
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

  def create_score(user_id, record_score, from_user_id)
    Score.create(:user_id => user_id, :value => -record_score,:from_user_id => from_user_id)
  end

  def self.jifen(b, u)
    us = UserScore.find_by(:beaconid=>b.id, :user_id=>u.id)
    us.total_score
  end

  def self.rank(b, u)

  end

end
