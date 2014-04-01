class AddGameTypeIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :game_type_id, :integer
  end
end
