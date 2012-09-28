class OldLocalRewardCategory < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_localrewardcategories'
  self.primary_key = 'id'
  has_many :old_reward_locals, :class_name => 'OldRewardLocals', :foreign_key => :rewardimageID, :inverse_of => :old_local_reward_category
  belongs_to :old_reward_image, :foreign_key => :rewardimageID, :inverse_of => :old_reward_locals, :class_name => "OldRewardImage"
end

