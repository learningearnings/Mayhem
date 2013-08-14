class AddSchoolIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :school_id, :integer
  end
end
