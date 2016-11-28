class AddSyncVersionsToSyncAttemp < ActiveRecord::Migration
  def change
  	add_column :sync_attempts, :student_version, :integer, limit: 8
  	add_column :sync_attempts, :section_version, :integer, limit: 8
  	add_column :sync_attempts, :staff_version, :integer, limit: 8
  	add_column :sync_attempts, :roster_version, :integer, limit: 8
  end
end
