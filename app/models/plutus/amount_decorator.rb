Plutus::Amount.class_eval do
  has_one :person_account_link, :foreign_key => :plutus_account_id, :primary_key => :account_id
end
