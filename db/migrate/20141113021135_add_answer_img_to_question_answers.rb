class AddAnswerImgToQuestionAnswers < ActiveRecord::Migration
  def change
    add_column :question_answers, :answer_img, :string
  end
end
