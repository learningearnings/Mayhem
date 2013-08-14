class OldFilter < ActiveRecord::Base
  establish_connection(:legacy)
  self.table_name = 'tbl_filters'

  attr_accessible :minschoolgrade,:maxschoolgrade, :createddate, :updateddate

  has_many :old_filter_classrooms, :class_name => 'OldFilterClassroom', :foreign_key => :filterID
  has_many :old_filter_states, :class_name => 'OldFilterState', :foreign_key => :filterID
  has_many :old_filter_usertypes, :class_name => 'OldFilterUsertype', :foreign_key => :filterID
  has_many :old_filter_schools, :class_name => 'OldFilterSchool', :foreign_key => :filterID

  has_many :old_classrooms,:class_name => 'OldClassroom', :through => :old_filter_classrooms, :foreign_key => :classroomID
  has_many :old_schools,:class_name => 'OldSchool', :through => :old_filter_schools, :foreign_key => :schoolID
  has_many :old_states,:class_name => 'OldState', :through => :old_filter_states, :foreign_key => :stateID
  has_many :old_usertypes,:class_name => 'OldUsertype', :through => :old_filter_usertypes, :foreign_key => :usertypeID

  has_many :old_reward_locals, :class_name => 'OldRewardLocal', :foreign_key => :filterID

  has_many :old_local_reward_categories, :class_name => 'OldLocalRewardCategory', :foreign_key => :filterID, :inverse_of => :old_filter

end
