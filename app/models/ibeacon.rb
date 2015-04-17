class Ibeacon < ActiveRecord::Base
  belongs_to :user  

  def user_name
    self.user.name if self.user
  end
end
