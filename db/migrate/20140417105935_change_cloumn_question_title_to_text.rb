class ChangeCloumnQuestionTitleToText < ActiveRecord::Migration
  def change
    change_column :questions, :question_title, :text
  end
end
