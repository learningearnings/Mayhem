class AddUsernameAndPasswordToStiSyncTokens < ActiveRecord::Migration
  def change
    add_column :sti_sync_tokens, :username, :string
    add_column :sti_sync_tokens, :password, :string
  end
end
