class AddIndexToOrderIdAndStateOnSpreeShipments < ActiveRecord::Migration
  def change
    add_index :spree_shipments, [:order_id, :state]
  end
end
