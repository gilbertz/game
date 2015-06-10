class CreateTeamworks < ActiveRecord::Migration
  def change
    create_table :teamworks do |t|
      t.integer :sponsor
      t.integer :total_work
      t.string :partner
      t.string :team_percent
      t.integer :material_id
      t.integer :state

      t.timestamps
    end
  end
end
