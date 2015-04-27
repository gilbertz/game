class CreateRedpackPerson < ActiveRecord::Migration
  def change
    create_table :redpack_people do |t|
      t.string :name
      t.integer :time_id
      t.integer :value_id
    end
  end
end
