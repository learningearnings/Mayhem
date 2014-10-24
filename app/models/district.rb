class District < ActiveRecord::Base
  attr_accessible :guid, :name, :alsde_study
  validates_presence_of :guid, :name

  def has_current_versions?
    current_staff_version.present? &&
    current_section_version.present? &&
    current_roster_version.present? &&
    current_student_version.present?
  end
end
