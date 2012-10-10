class OldClassroomDetail < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_classroomdetails'
  self.primary_key = 'classroomdetailID'
  belongs_to :old_classroom, :foreign_key => :classroomID,  :inverse_of => :students
end

