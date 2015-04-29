class CreateUserAllocations < ActiveRecord::Migration
  def change
    create_table :user_allocations do |t|
      t.integer :user_id
      t.integer :allocation

      t.timestamps
    end
  end
end
