class AddTAndCodeToAd < ActiveRecord::Migration
  def change
    add_column :ads, :t, :integer
    add_column :ads, :code, :text
  end
end
