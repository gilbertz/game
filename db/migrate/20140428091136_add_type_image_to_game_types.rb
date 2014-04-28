class AddTypeImageToGameTypes < ActiveRecord::Migration
  def change
    add_column :game_types, :type_image, :string
  end
end
