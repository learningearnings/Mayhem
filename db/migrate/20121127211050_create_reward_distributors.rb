class CreateRewardDistributors < ActiveRecord::Migration
  def change
    create_table :reward_distributors do |t|
      t.integer :person_school_link_id

      t.timestamps
    end
  end
end
