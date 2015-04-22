class AddGameIdToScore < ActiveRecord::Migration
  def change
    add_column :scores, :game_id, :integer
  end
end
