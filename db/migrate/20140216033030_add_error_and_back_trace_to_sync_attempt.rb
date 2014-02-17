class AddErrorAndBackTraceToSyncAttempt < ActiveRecord::Migration
  def change
    add_column :sync_attempts, :error, :string
    add_column :sync_attempts, :backtrace, :text
  end
end
