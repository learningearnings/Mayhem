class OldPoint < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_points'
  self.primary_key = 'pointID'
  belongs_to :old_user, :class_name => 'OldUser', :foreign_key => :userID
  belongs_to :old_otu_code, :foreign_key => 'otucodeID', :class_name => 'OldOtuCode'
end
