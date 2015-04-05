class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.integer :beacondid
      t.integer :user_id
      t.integer :state
      t.float :lng
      t.float :lat

      t.timestamps
    end
  end
end
