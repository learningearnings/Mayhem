class AddCreditDistributionAndRewardDeliveryBooleansToPeople < ActiveRecord::Migration
  def change
    add_column :people, :can_distribute_credits, :boolean
    add_column :people, :can_deliver_rewards, :boolean
  end
end
