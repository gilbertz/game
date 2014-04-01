class CreateGameType < ActiveRecord::Migration
  def change
    create_table :game_types do |t|
      t.string :game_type
      t.timestamps
    end
  end
end
