class OldFilterClassroom < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_filterclassrooms'


  belongs_to :old_filter, :class_name => 'OldFilter', :foreign_key => :filterID
  belongs_to :old_classroom, :class_name => 'OldClassroom', :foreign_key => :classroomID


end
