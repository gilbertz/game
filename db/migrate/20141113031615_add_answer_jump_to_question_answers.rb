class AddAnswerJumpToQuestionAnswers < ActiveRecord::Migration
  def change
    add_column :question_answers, :answer_jump, :integer
  end
end
