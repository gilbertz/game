class AddStoreToRedpack < ActiveRecord::Migration
  def change
    add_column :redpacks, :store, :integer
  end
end
