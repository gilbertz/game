class AddRedpackIdToRedpackPeople < ActiveRecord::Migration
  def change
    add_column :redpack_people, :redpack_id, :integer
  end
end
