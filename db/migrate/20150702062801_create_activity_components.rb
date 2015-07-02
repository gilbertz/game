class CreateActivityComponents < ActiveRecord::Migration
  def change
    create_table :activity_components do |t|
      t.integer :activity_id
      t.integer :component_id
      t.integer :status

      t.timestamps
    end
  end
end
