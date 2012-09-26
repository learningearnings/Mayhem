class OldClassroomDetail < ActiveRecord::Base
  establish_connection({:adapter => 'mysql2',
  :database =>'Snapshot',
  :username =>'import',
  :password => 'i82much'})
  self.table_name = 'tbl_classroomdetails'
  self.primary_key = 'classroomdetailID'
  belongs_to :old_classroom, :foreign_key => :classroomID,  :inverse_of => :students
end

