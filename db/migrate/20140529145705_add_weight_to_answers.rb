class AddWeightToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :weight, :integer
  end
end
