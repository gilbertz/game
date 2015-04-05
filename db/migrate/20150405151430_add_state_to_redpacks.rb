class AddStateToRedpacks < ActiveRecord::Migration
  def change
    add_column :redpacks, :state, :integer
  end
end
