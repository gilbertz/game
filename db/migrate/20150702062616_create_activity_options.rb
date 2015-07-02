class CreateActivityOptions < ActiveRecord::Migration
  def change
    create_table :activity_options do |t|
      t.date :begin_time
      t.date :end_time
      t.integer :activity_id

      t.timestamps
    end
  end
end
