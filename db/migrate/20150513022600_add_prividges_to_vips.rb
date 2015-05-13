class AddPrividgesToVips < ActiveRecord::Migration
  def change

    add_column :vips, :privileges, :string
  end
end
