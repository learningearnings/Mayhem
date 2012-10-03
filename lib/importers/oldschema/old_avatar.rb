class OldAvatar < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_avatars'
  self.primary_key = 'id'
  has_many :old_user_avatars, :class_name => 'OldUserAvatars',:foreign_key => :avatarID,  :inverse_of => :old_avatar
  belongs_to :old_avatars, :class_name => 'OldAvatar', :foreign_key => :avatarID, :inverse_of => :old_avatars
end
