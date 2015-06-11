class AddPatternToRedpack < ActiveRecord::Migration
  def change
    add_column :redpacks, :pattern, :integer
  end
end
