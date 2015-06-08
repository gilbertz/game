class AddTypeIdToRedpacks < ActiveRecord::Migration
  def change
    add_column :redpacks, :type_id, :integer
  end
end
