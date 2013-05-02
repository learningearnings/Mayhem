class OldRewardGlobal < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewardglobals'
  self.primary_key = 'rewardglobalID'
  has_one :old_reward, :foreign_key => :rewardID, :class_name => 'OldReward', :inverse_of => :old_reward_globals
end

