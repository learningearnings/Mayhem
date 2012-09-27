class OldReward < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewards'
  self.primary_key = 'rewardID'
  has_many :old_points, :foreign_key => :pointID, :class_name => 'OldPoint'
  has_many :old_reward_details, :foreign_key => :rewardID, :class_name => "OldRewardDetail"
  has_many :old_reward_locals, :foreign_key => :rewardID, :class_name => "OldRewardLocal"
  has_many :old_reward_globals, :foreign_key => :rewardID, :class_name => "OldRewardGlobal"
end

