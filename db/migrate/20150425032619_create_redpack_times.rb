class CreateRedpackTimes < ActiveRecord::Migration
  def change
    create_table :redpack_times do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :frequency
      t.integer :min
      t.integer :max
      t.integer :store
      t.integer :state
      t.integer :probability
    end
  end
end
