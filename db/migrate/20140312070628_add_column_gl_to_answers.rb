class AddColumnGlToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :big_than, :integer
    add_column :answers, :small_than, :integer
  end
end
