class AddTitleToWcards < ActiveRecord::Migration
  def change
    add_column :wcards, :title, :string
  end
end
