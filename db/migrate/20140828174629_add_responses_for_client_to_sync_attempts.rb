class AddResponsesForClientToSyncAttempts < ActiveRecord::Migration
  def change
    add_column :sync_attempts, :students_response, :text
    add_column :sync_attempts, :rosters_response, :text
    add_column :sync_attempts, :schools_response, :text
    add_column :sync_attempts, :sections_response, :text
    add_column :sync_attempts, :staff_response, :text
  end
end
