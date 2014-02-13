class Category < ActiveRecord::Base
  has_many :images, as: :viewable, class_name: "Image"
  has_many :materials, class_name: "Material" 

  before_destroy :check_its_materials
  private 
  def check_its_materials
    false if self.materials.length > 0
  end
end
