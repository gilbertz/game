class AboutPartyNeed < ActiveRecord::Migration
  def change
    #如果活动是团队合作的话则有这些字段
    add_column :materials, :team_persons, :integer
    add_column :materials, :one_percent, :float
    add_column :materials, :team_reward, :integer
    add_column :records, :material_id, :integer
    add_column :materials, :party_id, :integer

    add_index :materials, :party_id

    add_index :parties, :openid

    add_index :teamworks,:sponsor
    add_index :teamworks,:material_id
    add_index :teamworks,:state
    add_index :teamworks,:created_at

    add_index :teamworks, [:sponsor, :material_id]
    add_index :teamworks, [:sponsor, :material_id,:state]
    add_index :teamworks, [:sponsor, :material_id,:state,:created_at],:name => "index_teamwoks_sponsor_state"

  end
end
