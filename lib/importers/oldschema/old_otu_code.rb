class OldOtuCode < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_otucodes'
  self.primary_key = 'otucodeID'
  belongs_to :old_user, :class_name => 'OldUser', :foreign_key => :userID
  has_one :old_point, :foreign_key => :pointID, :class_name => 'OldPoint'
end
