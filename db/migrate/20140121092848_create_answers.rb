class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string   :title
      t.string   :group
      t.string   :img
      t.integer  :viewable_id
      t.string   :viewable_type

      t.timestamps
    end
    add_index :answers, [:viewable_id, :viewable_type]
  end
end
