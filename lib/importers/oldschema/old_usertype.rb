class OldUsertype < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_usertype'
  self.primary_key = 'usertypeID'
  attr_accessible :usertype, :status_id
  has_many :old_users, :class_name => 'OldUser',:foreign_key => :userID
  has_many :filter_usertypes, :class_name => 'OldFilterUsertype', :foreign_key => :usertypeID
  has_many :filters, :class_name => 'OldFilter', :through => :filter_usertypes, :source => :old_filter
end
