class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string   :title
      t.integer  :viewable_id
      t.string   :viewable_type
      t.integer  :state
      t.string   :body

      t.timestamps
    end
    add_index :images, [:viewable_id, :viewable_type]
  end
end
