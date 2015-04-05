class CreateBurls < ActiveRecord::Migration
  def change
    create_table :burls do |t|
      t.string :url
      t.integer :beaconid
      t.integer :weight
      t.integer :state
      t.integer :pv
      t.integer :uv
      t.string :title
      t.string :img
      t.string :remark

      t.timestamps
    end
  end
end
