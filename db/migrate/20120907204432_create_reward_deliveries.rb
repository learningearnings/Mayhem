class CreateRewardDeliveries < ActiveRecord::Migration
  def change
    create_table :reward_deliveries do |t|
      t.integer :from_id
      t.integer :to_id
      t.integer :reward_id
      t.string  :status
      t.timestamps
    end
  end
end
