class AddHidePyqToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :hide_pyq, :boolean
  end
end
