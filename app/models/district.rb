class District < ActiveRecord::Base
  attr_accessible :guid, :name, :alsde_study
  validates_presence_of :guid
  has_many :school_credits
  has_many :teacher_credits
  attr_accessible :current_staff_version, :current_section_version, :current_roster_version, :current_student_version

  def has_current_versions?
    current_staff_version.present? &&
    current_section_version.present? &&
    current_roster_version.present? &&
    current_student_version.present?
  end
end
