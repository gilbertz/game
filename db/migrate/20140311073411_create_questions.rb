class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :material_id
      t.string :question_title
      t.timestamps
    end

    add_index :questions, :material_id
  end
end
