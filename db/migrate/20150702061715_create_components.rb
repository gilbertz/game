class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.integer :party_id
      t.integer :appearance_id
      t.string :obj_type
      t.integer :obj_id
      t.integer :component_template_id

      t.timestamps
    end
  end
end
