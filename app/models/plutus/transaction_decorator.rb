Plutus::Transaction.class_eval do
  belongs_to :spree_product,:foreign_key => :commercial_document_id,  :foreign_type => :commercial_document_type, :class_name => 'Spree::Product'
  belongs_to :otu_code,:foreign_key => :commercial_document_id,  :foreign_type => :commercial_document_type, :class_name => 'OtuCode'
  #  has_many :amounts, :class_name => "Plutus::Amount", :inverse_of => :transaction
  has_one  :transaction_order
  has_one  :order, through: :transaction_order

  has_many :person_account_links, :class_name => 'PersonAccountLink', :through => :amounts, :inverse_of => :amounts, :source => :person_account_link
  has_many :person_school_links, :class_name => 'PersonSchoolLink' ,:through => :person_account_links
  has_many :people, :through => :person_school_links, :class_name => 'Person'
  scope :with_spree_products, where(:commercial_document_type => 'Spree::Product')
  scope :with_spree_line_items, where(:commercial_document_type => 'Spree::LineItem')
  scope :for_account, lambda {|account_id| joins(:amounts).where("#{Plutus::Amount.table_name}.account_id" => account_id)}
  scope :for_accounts, lambda {|accounts| joins(:amounts).where("#{Plutus::Amount.table_name}.account_id" => accounts)}
  scope :for_person, lambda {|person_id| joins(:person_school_links).where("#{PersonSchoolLink.table_name}.person_id" => person_id)}
  scope :with_main_account, joins(:person_account_links).where("#{PersonAccountLink.table_name}.is_main_account" => true)
  scope :created_between, lambda {|start_date, end_date| where(created_at: start_date..end_date)}

  has_many :product_properties, :through => :spree_product, :class_name => 'Spree::ProductProperty'
  has_many :properties, :through => :product_properties, :class_name => 'Spree::Property'
  attr_accessible :credit_amounts, :debit_amounts

  def self.build(hash)
    transaction = Plutus::Transaction.new(:description => hash[:description], :commercial_document => hash[:commercial_document])
    hash[:debits].each do |debit|
      a = debit[:account] if debit[:account].is_a? Plutus::Account
      a = Plutus::Account.find_by_name(debit[:account]) if debit[:account].is_a? String
      transaction.debit_amounts << Plutus::DebitAmount.new(:account => a, :amount => debit[:amount], :transaction => transaction)
    end
    hash[:credits].each do |credit|
      a = credit[:account] if credit[:account].is_a? Plutus::Account
      a = Plutus::Account.find_by_name(credit[:account]) if credit[:account].is_a? String
      transaction.credit_amounts << Plutus::CreditAmount.new(:account => a, :amount => credit[:amount], :transaction => transaction)
    end
    transaction
  end
  def reward_deliverer
    RewardDelivery.joins(reward:[{order: :transaction}]).where("plutus_transactions.id= ?", id).first.try(:from).try(:full_name)
  end
  def credit_source
    self.try(:otu_code).try(:teacher).try(:full_name)
  end
  def transaction_description
    ["Transfer from Checking to Savings", "Transfer from Savings to Checking","Transfer from Checking to Hold","Transfer from Hold to Checking"].include? self.description
  end
end
