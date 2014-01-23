class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string   :define
      t.string   :title
      t.integer  :material_id
      t.integer  :state
      t.string   :body 

      t.timestamps
    end
    add_index :images, [:material_id]
  end
end
