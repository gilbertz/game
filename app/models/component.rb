class Component < ActiveRecord::Base
  belongs_to :party
  belongs_to :component_template
  has_many :activity_components
end
