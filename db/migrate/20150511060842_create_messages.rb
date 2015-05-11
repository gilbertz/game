class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :beaconid
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.integer :count
      t.integer :state

      t.timestamps
    end
  end
end
