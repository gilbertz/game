class AddTargetIdAndTargetTypeToBurl < ActiveRecord::Migration
  def change
    add_column :burls, :target_id, :integer
    add_column :burls, :target_type, :string
  end
end
