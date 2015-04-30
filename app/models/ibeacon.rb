class Ibeacon < ActiveRecord::Base
  belongs_to :user  
  has_many :bgames, :foreign_key => "beaconid"
  has_many :cards, :foreign_key => "beaconid"
  has_many :redpacks, :foreign_key => "beaconid"
  has_many :records, :foreign_key => "beaconid"
  has_many :scores, :foreign_key => "beaconid"
  has_many :user_scores, :foreign_key => "beaconid"  
  has_many :checks, :foreign_key => "beaconid"

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

  def cloning(recursive=false)
    Ibeacon.create self.attributes.except!("created_at", "id")
  end

end
