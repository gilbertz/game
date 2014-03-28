class AddShowCountAndClickCountToAds < ActiveRecord::Migration
  def change
    add_column :ads, :show_count, :integer
    add_column :ads, :click_count, :integer
  end
end
