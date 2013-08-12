class OldClassroomDetail < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_classroomdetails'
  self.primary_key = 'classroomdetailID'
  belongs_to :old_classroom, :foreign_key => :classroomID,  :inverse_of => :classroom_details
  belongs_to :student, :class_name => 'OldUser',:foreign_key => :userID
end

