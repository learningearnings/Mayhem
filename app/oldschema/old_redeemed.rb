class OldRedeemed < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_redeemed'
  self.primary_key = 'redeemedID'
  belongs_to :old_reward, :foreign_key => :rewardID, :class_name => OldReward, :inverse_of => :old_redeemeds
  belongs_to :old_reward_detail, :foreign_key => :rewarddetailID, :class_name => OldRewardDetail, :inverse_of => :old_redeemeds
  belongs_to :old_reward_local, :foreign_key => :rewardlocalID, :class_name => OldRewardLocal, :inverse_of => :old_redeemeds
  belongs_to :old_reward_global, :foreign_key => :rewardglobalID, :class_name => OldRewardGlobal, :inverse_of => :old_redeemeds
end

