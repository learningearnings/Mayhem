class AddCanDistributeRewardsToPersonSchoolLinks < ActiveRecord::Migration
  def change
    add_column :person_school_links, :can_distribute_rewards, :boolean, default: false

    # Copy data from rewards_delivery
    PersonSchoolLink.where(id: RewardDistributor.pluck(:person_school_link_id)).update_all(can_distribute_rewards: true)
  end
end
