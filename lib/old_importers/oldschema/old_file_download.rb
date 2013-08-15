class OldFileDownload < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_filedownload'
  self.primary_key = 'filedownloadid'
  belongs_to :old_userid, :class_name => 'OldUser', :foreign_key => :userid
  has_many :old_teacher_awards, :class_name => 'OldTeacherAward', :foreign_key => :filedownloadid, :inverse_of => :old_file_downloads
end
