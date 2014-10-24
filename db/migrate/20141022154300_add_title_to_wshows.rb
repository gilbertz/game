class AddTitleToWshows < ActiveRecord::Migration
  def change
    add_column :wshows, :title, :string
  end
end
