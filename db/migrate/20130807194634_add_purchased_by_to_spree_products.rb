class AddPurchasedByToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :purchased_by, :string
  end
end
