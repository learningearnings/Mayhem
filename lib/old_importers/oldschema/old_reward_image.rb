class OldRewardImage < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_rewardimages'
  has_many :old_reward_locals, :foreign_key => :rewardimageID, :inverse_of => :old_reward_image
  has_many :old_local_reward_categories, :foreign_key => :rewardimageID, :inverse_of => :old_reward_image
end

