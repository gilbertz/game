class Material < ActiveRecord::Base

  belongs_to :category
  has_many :images, as: :viewable, class_name: "Image", dependent: :destroy 
  has_many :answers, as: :viewable, class_name: "Answer",  dependent: :destroy 

  class_attribute :clone 
  before_update :clone_self, if: Proc.new{|mate| mate.clone == true}
  def cloning(param)
    self.update_attribute(:clone,param)
  end

  def invert_state
    val = state.eql?(0) ? 1 : 0
    self.update_attributes(state: val)
  end

  def cn_state; { 0 => '下线', 1 => '上线', nil => '下线' }[state] end

  private
  def clone_self
    material = Material.new self.attributes.except!("created_at","id")
    material.state = 0
    material.images  = self.images.map {|img| Image.new img.attributes.except!("id") }
    material.answers = self.answers.map{|asw| Answer.new asw.attributes.except!("id")}
    material.save
  end
end
