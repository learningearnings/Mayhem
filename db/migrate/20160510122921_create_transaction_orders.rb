class CreateTransactionOrders < ActiveRecord::Migration
  def change
    create_table :transaction_orders do |t|
      t.integer :transaction_id
      t.integer :order_id
    end
  end
end
