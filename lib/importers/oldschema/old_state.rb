class OldState < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_states'
  self.primary_key = 'stateID'


  has_many :filter_states, :class_name => 'OldFilterState', :foreign_key => 'stateID'
  has_many :filters, :class_name => 'OldFilter', :through => :filter_states, :source => :old_filter
end

