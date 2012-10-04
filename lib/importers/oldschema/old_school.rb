class OldSchool < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_schools'
  self.primary_key = 'schoolID'

#  scope :school_subset,  where(:schoolID => [91,215,229,221,98,830,483,412,96,633,873,538,121,94,277]).where('status_id = 200 and ad_profile < 21')
  scope :school_subset,  where(:schoolID => [98,215,221,830,483,523]).where('status_id = 200 and ad_profile < 20')
#  scope :school_subset,  where(:schoolID => [98,215]).where('status_id = 200 and ad_profile < 20')

  belongs_to :state, :class_name => OldState
  has_many :old_users, :foreign_key => :schoolID
  has_many :classrooms, :foreign_key => :schoolID, :class_name => 'OldClassroom'
end
