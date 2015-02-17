class ChangeSyncAttemptsErrorFieldFromStringToText < ActiveRecord::Migration
  def up
    change_column :sync_attempts, :error, 'text USING CAST(error AS text)'
  end

  def down
    #change_column :sync_attempts, :error, 'string USING CAST(error AS string)'
  end
end
