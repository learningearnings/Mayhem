class OldTeacherAward < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_teacherawards'
  self.primary_key = 'TeacherAwardID'
  belongs_to :old_teacher, :class_name => 'OldUser', :foreign_key => :TeacherID
  belongs_to :old_student, :class_name => 'OldUser', :foreign_key => :StudentID
  has_one :old_otu_code, :foreign_key => :TeacherAwardID, :class_name => 'OldOtuCode'
  belongs_to :old_file_download, :class_name => 'OldFileDownload', :foreign_key => :filedownloadid
end
