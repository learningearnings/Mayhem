class CreateSyncAttempts < ActiveRecord::Migration
  def change
    create_table :sync_attempts do |t|
      t.string :district_guid
      t.string :status
      t.string :sync_type

      t.timestamps
    end
  end
end
