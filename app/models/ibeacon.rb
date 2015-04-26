class Ibeacon < ActiveRecord::Base
  belongs_to :user  

  def user_name
    self.user.name if self.user
  end

  def self.get_ibeacons_for_select(user_id=nil)
    cond = '1=1'
    if user_id
      cond='user_id=user_id'
    end 
    ibs = Ibeacon.where(cond).order('created_at desc').limit(50)
    ibs.map{|b|[b.name, b.id]}
  end

end
