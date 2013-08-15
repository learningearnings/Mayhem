class OldFilterState < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_filterstates'

  attr_accessible :minschoolgrade,:maxschoolgrade, :createddate, :updateddate

  belongs_to :old_filter, :class_name => 'OldFilter', :foreign_key => :filterID
  belongs_to :old_state, :class_name => 'OldState', :foreign_key => :stateID

end
