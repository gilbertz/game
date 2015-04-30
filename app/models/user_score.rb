class UserScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :ibeacon

  def self.total_score(user_id, beaconid)
    us = UserScore.find_by(:user_id => user_id, :beaconid => beaconid )
    us.total_score
  end
end
