class AddOnToWcards < ActiveRecord::Migration
  def change
    add_column :wcards, :state, :integer
    add_column :wcards, :thumb, :string
    add_column :wcards, :url, :string
  end
end
