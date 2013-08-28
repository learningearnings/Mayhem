class PersonAccountLink < ActiveRecord::Base
  attr_accessible :person_school_link_id, :plutus_account_id, :is_main_account
  belongs_to :account, :class_name => 'Plutus::Account', :foreign_key => :plutus_account_id
  belongs_to :plutus_account, :class_name => 'Plutus::Account', :foreign_key => :plutus_account_id, :inverse_of => :person_account_link
  belongs_to :person_school_link
  has_many :amounts, :through => :account, :class_name => 'Plutus::Amount'
  has_one :school, :through => :person_school_link
  has_one :person, :through => :person_school_link
  scope :with_main_account, where(:is_main_account => true)
  scope :with_account_balance, with_main_account.joins(:account).includes(:account)

  def self.for_school(school)
    includes(:person_school_link).where(:person_school_link => { :school_id => school.id })
  end
end
