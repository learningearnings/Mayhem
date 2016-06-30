class AddDeliveredByToRewardDelivery < ActiveRecord::Migration
  def change
    add_column :reward_deliveries, :delivered_by_id, :integer
  end
end
