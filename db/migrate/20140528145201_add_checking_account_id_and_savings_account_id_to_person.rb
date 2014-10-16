class AddCheckingAccountIdAndSavingsAccountIdToPerson < ActiveRecord::Migration
  def change
    add_column :people, :checking_account_id, :integer
    add_column :people, :savings_account_id, :integer
  end
end
