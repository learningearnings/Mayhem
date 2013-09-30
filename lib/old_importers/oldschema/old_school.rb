class OldSchool < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_schools'
  self.primary_key = 'schoolID'

#  scope :school_subset,  where(:schoolID => [91,215,229,221,98,830,483,412,96,633,873,538,121,94,277]).where('status_id = 200 and ad_profile < 21')
  scope :school_subset,  where(:schoolID => [98,215,221,830,483,523]).where('status_id = 200')
  scope :school_subset1,  where(:schoolID => [98,221]).where('status_id = 200')
  scope :school_subset2,  where(:schoolID => [215]).where('status_id = 200')
  scope :school_subset3,  where(:schoolID => [830,483]).where('status_id = 200')
  scope :school_subset4,  where(:schoolID => [523]).where('status_id = 200')
#  scope :school_subset,  where(:schoolID => [98,215]).where('status_id = 200')
#  scope :school_subset,  where(:schoolID => [98]).where('status_id = 200')

  belongs_to :state, :class_name => OldState
  has_many :old_users, :foreign_key => :schoolID
  has_many :filter_schools, :class_name => 'OldFilterSchool', :foreign_key => :schoolID, :inverse_of => :old_school
  has_many :filters, :class_name => 'OldFilter', :through => :filter_schools, :inverse_of => :old_schools, :source => :old_filter
  has_many :classrooms, :foreign_key => :schoolID, :class_name => 'OldClassroom'
end
