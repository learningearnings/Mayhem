class ChangeSyncAttemptTextLimit < ActiveRecord::Migration
  def up
  	change_column :sync_attempts, :students_response, :text, :limit => 16777216
  	change_column :sync_attempts, :rosters_response, :text, :limit => 16777216
  	change_column :sync_attempts, :schools_response, :text, :limit => 16777216
  	change_column :sync_attempts, :sections_response, :text, :limit => 16777216
  	change_column :sync_attempts, :staff_response, :text, :limit => 16777216
  end

  def down
  	change_column :sync_attempts, :students_response, :text
  	change_column :sync_attempts, :rosters_response, :text
  	change_column :sync_attempts, :schools_response, :text
  	change_column :sync_attempts, :sections_response, :text
  	change_column :sync_attempts, :staff_response, :text
  end
end
