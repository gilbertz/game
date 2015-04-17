class Ibeacon < ActiveRecord::Base
  belongs_to :user  

  def user_name
    self.user_name
  end
end
