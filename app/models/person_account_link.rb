class PersonAccountLink < ActiveRecord::Base
  attr_accessible :person_school_link_id, :plutus_account_id
  belongs_to :plutus_account, :class_name => 'Plutus::Account'
  belongs_to :person_school_link
  has_one :school, :through => :person_school_link
  has_one :person, :through => :person_school_link
end
