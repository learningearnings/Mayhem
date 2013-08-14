class OldFilterSchool < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_filterschools'

  belongs_to :old_filter, :class_name => 'OldFilter', :foreign_key => :filterID
  belongs_to :old_school, :class_name => 'OldSchool', :foreign_key => :schoolID

end
