class AddLastNoticeTimeToChecks < ActiveRecord::Migration
  def change
    add_column :checks,:last_notice_time,:datetime
  end
end
