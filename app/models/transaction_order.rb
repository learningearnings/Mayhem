class TransactionOrder < ActiveRecord::Base
  attr_accessible :order_id, :transaction_id
  belongs_to :transaction, class_name: "Plutus::Transaction", foreign_key: :transaction_id
  belongs_to :order, class_name: "Spree::Order", foreign_key: :order_id
end
