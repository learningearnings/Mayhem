class RenameFullfillmentTypeToFulfillmentTypeOnSpreeProducts < ActiveRecord::Migration
  def change
    rename_column :spree_products, :fullfillment_type, :fulfillment_type
  end
end
