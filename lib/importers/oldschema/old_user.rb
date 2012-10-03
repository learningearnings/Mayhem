class OldUser < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_users'
  self.primary_key = 'userID'
  belongs_to :old_school, :class_name => 'OldSchool',:foreign_key => :schoolID,  :inverse_of => :old_users
  has_many :old_user_avatars, :class_name => 'OldUserAvatar', :foreign_key => :userID, :inverse_of => :old_user, :order => 'id desc'
  has_many :old_avatars, :class_name => 'OldAvatar', :through => :old_user_avatars
  has_many :old_points, :foreign_key => :userID

  def avatar
    old_ua = old_user_avatars.where(:status_id => 200).order('id desc').first
    @displayname = old_ua.displayname if old_ua
    old_ua.old_avatar if old_ua && old_ua.old_avatar
  end

  def displayname
    return @displayname if @displayname
    old_ua = old_user_avatars.where(:status_id => 200).order('id desc')
    @displayname ||= old_ua.displayname if old_ua && old_ua.displayname
  end


end
