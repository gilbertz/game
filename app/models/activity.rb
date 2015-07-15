class Activity < ActiveRecord::Base
  belongs_to :party
  belongs_to :activity_template
  has_many :activity_options
  has_many :activity_components


  before_create :gen_activity_uuid

  def gen_uuid
    self.uuid = SecureRand.uuid
  end

end
