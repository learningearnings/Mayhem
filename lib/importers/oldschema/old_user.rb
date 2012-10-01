class OldUser < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_users'
  self.primary_key = 'userID'
  belongs_to :old_school, :class_name => OldSchool,:foreign_key => :schoolID,  :inverse_of => :old_users
  has_many :old_points, :foreign_key => :userID
end
