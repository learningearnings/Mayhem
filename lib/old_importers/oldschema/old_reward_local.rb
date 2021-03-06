class OldRewardLocal < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewardlocals'
  self.primary_key = 'id'
  belongs_to :filter, :class_name => 'OldFilter', :foreign_key => :filterID
  belongs_to :old_user, :class_name => 'OldUser', :foreign_key => :userID
  belongs_to :old_reward, :class_name => 'OldReward', :foreign_key => :rewardID

  belongs_to :old_redeemed, :foreign_key => :rewardID, :class_name => 'OldRedeemed', :inverse_of => :old_reward_local
  belongs_to :old_local_reward_category, :foreign_key => :localrewardcategoryID, :inverse_of => :old_reward_locals, :class_name => "OldLocalRewardCategory"
  has_one :old_reward_image,:through => :old_local_reward_category, :inverse_of => :old_reward_locals, :class_name => "OldRewardImage"
end

