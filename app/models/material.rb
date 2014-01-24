class Material < ActiveRecord::Base

  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :images, dependent: :destroy

  class_attribute :clone 
  before_update :clone_self, if: Proc.new{|mate| mate.clone == true}
  def cloning(param)
    self.update_attribute(:clone,param)
  end

  def html_img(index); images.select{|img| img.state == 1 }[index-1].try(:body) end
  def css_img(index); images.select{|img| img.state == 2 }[index-1].try(:body) end
  def js_img(index); images.select{|img| img.state == 3 }[index-1].try(:body) end

  private
  def clone_self
    material = Material.new self.attributes.except!("created_at","id")
    material.images  = self.images.map {|img| Image.new img.attributes.except!("id") }
    material.answers = self.answers.map{|asw| Answer.new asw.attributes.except!("id")}
    material.save
  end
end
