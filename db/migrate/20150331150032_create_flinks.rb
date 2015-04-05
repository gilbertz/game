class CreateFlinks < ActiveRecord::Migration
  def change
    create_table :flinks do |t|
      t.integer :beaconid
      t.string :wxid
      t.string :wxurl
      t.integer :state

      t.timestamps
    end
  end
end
