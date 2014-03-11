class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|

      t.integer :question_id, :null => false
      t.string :answer, :null => false
      t.integer :answer_score, :null => false, :default => 0

    end

    add_index :question_answers, :question_id

  end
end
