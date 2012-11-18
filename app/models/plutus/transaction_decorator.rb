Plutus::Transaction.class_eval do
  belongs_to :spree_product,:foreign_key => :commercial_document_id,  :foreign_type => :commercial_document_type, :class_name => 'Spree::Product', :polymorphic => true

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
end
