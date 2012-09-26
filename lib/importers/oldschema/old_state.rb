class OldState < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_states'
  self.primary_key = 'stateID'
end

