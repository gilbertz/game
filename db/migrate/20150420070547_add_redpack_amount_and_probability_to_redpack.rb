class AddRedpackAmountAndProbabilityToRedpack < ActiveRecord::Migration
  def change
    add_column :redpacks, :amount, :integer
    add_column :redpacks, :probability, :integer
  end
end
