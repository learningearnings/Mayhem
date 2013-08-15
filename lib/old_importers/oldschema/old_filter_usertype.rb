class OldFilterUsertype < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_filterusertypes'


  belongs_to :old_filter, :class_name => 'OldFilter', :foreign_key => :filterID
  belongs_to :old_usertype, :class_name => 'OldUsertype', :foreign_key => :usertypeID


end
