class OldClassroom < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_classrooms'
  self.primary_key = 'classroomID'
  belongs_to :teacher, :class_name => OldUser, :foreign_key => :userID
  has_many :classroom_details, :class_name => 'OldClassroomDetail', :foreign_key => :classroomID
  has_many :students, :class_name => OldUser, :foreign_key => :userID
  belongs_to :school, :class_name => OldSchool,:foreign_key => :schoolID,  :inverse_of => :old_users
end
