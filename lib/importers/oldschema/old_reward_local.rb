class OldRewardLocal < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewardlocals'
  self.primary_key = 'id'
  belongs_to :old_redeemed, :foreign_key => :rewardID, :class_name => 'OldRedeemed', :inverse_of => :old_reward_local
end

