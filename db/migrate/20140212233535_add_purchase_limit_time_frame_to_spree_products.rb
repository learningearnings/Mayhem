class AddPurchaseLimitTimeFrameToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :purchase_limit_time_frame, :string
  end
end
