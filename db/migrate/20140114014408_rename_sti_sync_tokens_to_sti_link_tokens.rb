class RenameStiSyncTokensToStiLinkTokens < ActiveRecord::Migration
  def up
    rename_table :sti_sync_tokens, :sti_link_tokens
    rename_column :sti_link_tokens, :sync_key, :link_key
  end

  def down
  end
end
