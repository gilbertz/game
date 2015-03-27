class AddInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :sex, :integer
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :language, :string
    add_column :users, :province, :string
    
  end
end
