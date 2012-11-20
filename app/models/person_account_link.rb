class PersonAccountLink < ActiveRecord::Base
  attr_accessible :person_school_link_id, :plutus_account_id, :is_main_account
  belongs_to :account, :class_name => 'Plutus::Account', :foreign_key => :plutus_account_id, :inverse_of => :person_account_link
  belongs_to :person_school_link
  has_many :amounts, :through => :account, :class_name => 'Plutus::Amount'
  has_one :school, :through => :person_school_link
  has_one :person, :through => :person_school_link
end
