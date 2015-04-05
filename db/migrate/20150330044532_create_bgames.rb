class CreateBgames < ActiveRecord::Migration
  def change
    create_table :bgames do |t|
      t.integer :ibeacon_id
      t.integer :game_id
      t.integer :state
      t.string :remark

      t.timestamps
    end
  end
end
