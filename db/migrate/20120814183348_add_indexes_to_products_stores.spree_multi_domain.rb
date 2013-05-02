# This migration comes from spree_multi_domain (originally 20110601145424)
class AddIndexesToProductsStores < ActiveRecord::Migration
  def self.up
    add_index :products_stores, :product_id
    add_index :products_stores, :store_id
  end

  def self.down
    remove_index :products_stores, :product_id
    remove_index :products_stores, :store_id
  end
end
