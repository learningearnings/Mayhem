class CreateStiSyncTokens < ActiveRecord::Migration
  def change
    create_table :sti_sync_tokens do |t|
      t.string :district_guid
      t.string :api_url
      t.string :sync_key

      t.timestamps
    end
  end
end
