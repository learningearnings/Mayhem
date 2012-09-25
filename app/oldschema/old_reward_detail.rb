class OldRewardDetail < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewarddetails'
  self.primary_key = 'rewarddetailID'
#  has_one :old_point, :foreign_key => :pointID, :class_name => 'OldPoint'
#  has_many :reward_details, :foreign_key => :rewardID, :class_name => OldRewardDetails
end

