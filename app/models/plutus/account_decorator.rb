Plutus::Account.class_eval do
  has_one :person_account_link, :foreign_key => :plutus_account_id, :class_name => 'PersonAccountLink', :inverse_of => :plutus_account

  def self.update_cached_balances
    Plutus::Account.find_each do |account|
      account.update_attribute(:cached_balance, account.balance)
    end
  end
end
