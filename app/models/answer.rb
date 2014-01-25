class Answer < ActiveRecord::Base
  belongs_to :viewable, class_name: "Material", polymorphic: true
end
