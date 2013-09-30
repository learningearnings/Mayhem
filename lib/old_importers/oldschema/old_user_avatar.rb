class OldUserAvatar < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_useravatars'
  self.primary_key = 'id'
  belongs_to :old_user, :class_name => 'OldUser',:foreign_key => :userID # ,  :inverse_of => :old_user_avatar
  belongs_to :old_avatar, :class_name => 'OldAvatar', :foreign_key => :avatarID, :inverse_of => :old_user_avatars
end
