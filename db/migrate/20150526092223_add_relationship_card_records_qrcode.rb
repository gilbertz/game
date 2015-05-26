class AddRelationshipCardRecordsQrcode < ActiveRecord::Migration
  def change
    add_column :qrcodes, :card_record_id, :integer


    add_column :card_records, :status, :integer

  end
end
