class OldRewardLocal < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewardlocals'
  self.primary_key = 'id'
  belongs_to :old_reward, :foreign_key => :rewardID, :class_name => OldReward, :inverse_of => :old_reward_locals
end

