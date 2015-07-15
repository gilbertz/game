class Component < ActiveRecord::Base
  belongs_to :party
  belongs_to :component_template
  has_many :activity_components

  before_create :gen_component_uuid

  def gen_component_uuid
    uuid = SecureRand.uuid
    self.uuid = uuid
    self.url = ComponentTemplate.find_by_component_template_id(self.component_template_id).route_url
  end

  def get_state_url
    "#{self.url}/#{self.uuid}"
  end


end
