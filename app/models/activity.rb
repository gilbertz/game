class Activity < ActiveRecord::Base
  belongs_to :party
  belongs_to :activity_template
  has_many :activity_options
  has_many :activity_components

end
