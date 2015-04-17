class AddPhotoNamePhotoPathToImages < ActiveRecord::Migration
  def change
    add_column :images, :photo_name, :string
    add_column :images, :photo_path, :string
  end
end
