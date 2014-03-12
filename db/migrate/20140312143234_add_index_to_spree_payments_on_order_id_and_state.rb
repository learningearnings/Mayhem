class AddIndexToSpreePaymentsOnOrderIdAndState < ActiveRecord::Migration
  def change
    add_index :spree_payments, [:order_id, :state]
  end
end
