class AddRewardExclusions < ActiveRecord::Migration
  def change
    create_table :reward_exclusions do |t|
      t.integer :school_id
      t.integer :product_id
    end
  end
end
