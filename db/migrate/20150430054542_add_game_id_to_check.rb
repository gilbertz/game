class AddGameIdToCheck < ActiveRecord::Migration
  def change
    add_column :checks, :game_id, :integer
  end
end
