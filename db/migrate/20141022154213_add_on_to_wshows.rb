class AddOnToWshows < ActiveRecord::Migration
  def change
    add_column :wshows, :state, :integer
    add_column :wshows, :thumb, :string
    add_column :wshows, :url, :string
  end
end
