class QuestionAnswer < ActiveRecord::Base

  belongs_to :question

  def get_next_question(i)
    if self.answer_jump.to_i == 0
      i+1
    else
      self.answer_jump.to_i
    end
  end

end
