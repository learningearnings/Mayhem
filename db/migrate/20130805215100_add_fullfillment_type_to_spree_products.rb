class AddFullfillmentTypeToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :fullfillment_type, :string
  end
end
