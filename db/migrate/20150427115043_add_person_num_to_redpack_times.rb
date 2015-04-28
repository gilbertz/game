class AddPersonNumToRedpackTimes < ActiveRecord::Migration
  def change
    add_column :redpack_times, :person_num, :integer
  end
end
