class Category < ActiveRecord::Base
  has_many :images, as: :viewable, class_name: "Image"
  has_many :materials, class_name: "Material" 
end
