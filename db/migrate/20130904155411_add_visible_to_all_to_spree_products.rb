class AddVisibleToAllToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :visible_to_all, :boolean, :default => false
  end
end
