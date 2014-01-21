class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string   :title
      t.string   :img
      t.integer  :material_id


      t.timestamps
    end
    add_index :answers, [:material_id]
  end
end
