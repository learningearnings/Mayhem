class AddCachedBalanceToPlutusAccounts < ActiveRecord::Migration
  def change
    add_column :plutus_accounts, :cached_balance, :decimal, :precision => 20, :scale => 10
  end
end
