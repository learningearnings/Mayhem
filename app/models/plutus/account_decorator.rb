Plutus::Account.class_eval do
  has_one :person_account_link, :foreign_key => :plutus_account_id, :class_name => 'PersonAccountLink', :inverse_of => :account
end
