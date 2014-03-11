class Question < ActiveRecord::Base

  belongs_to :material
  has_many :question_answers

end