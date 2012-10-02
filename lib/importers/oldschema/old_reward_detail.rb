class OldRewardDetail < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewarddetails'
  self.primary_key = 'rewarddetailID'
  belongs_to :old_reward, :foreign_key => :rewardID, :class_name => 'OldReward'
  belongs_to :old_school, :foreign_key => :schoolID, :class_name => 'OldSchool'
#  has_many :reward_details, :foreign_key => :rewardID, :class_name => OldRewardDetails
end

