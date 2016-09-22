require 'basic_statuses'

class PersonSchoolClassroomLink < ActiveRecord::Base
  state_machine :status, :initial => :active do
  end
  include BasicStatuses
  belongs_to :person_school_link, :inverse_of => :person_school_classroom_links
  belongs_to :classroom
  has_one :teacher, :through => :person_school_link, :source => :person, :class_name => 'Teacher'
  has_one :student, :through => :person_school_link, :source => :person, :class_name => 'Student'
  has_one :person, through: :person_school_link, source: :person
  has_many :audit_logs, :as => :log_event

  attr_accessible :owner, :person_school_link_id, :status, :classroom_id, :homeroom

  validates_presence_of :person_school_link_id, :classroom_id
  validate :validate_unique_with_status
  validate :singularity_of_homeroom

  def link(d)
    if d && d.is_a?(Hash)
      self.classroom_id = d[:classroom_id] if d[:classroom_id]
      self.person_school_link_id = d[:person_school_link_id] if d[:person_school_link_id]
      self.classroom_id = d[:classroom].id if d[:classroom]
      self.person_school_link_id = d[:person_school_link].id if d[:person_school_link]
    end
  end

  def person
    self.person_school_link.person
  end

  ################### Validations ########################

  #
  # There can be an unlimited number of person_id -> school_id combinations that *don't* have status == "active"
  # but only one active one for a person -> school combination
  def validate_unique_with_status
  #  pscl = PersonSchoolClassroomLink.where(:person_school_link_id => self.person_school_link_id, :classroom_id => self.classroom_id, :status => 'active')
    pscl = PersonSchoolClassroomLink.where(:person_school_link_id => self.person_school_link_id, :classroom_id => self.classroom_id).status_active
    if self.id
      pscl = pscl.where("id != #{self.id}")
    end
    if pscl.length > 0
      errors.add(:status, "Person is already associated with this classroom")
    end
  end

  def singularity_of_homeroom
    if self.homeroom && pscl = person.person_school_classroom_links.where(homeroom: true).first
      errors.add(:homeroom, "Person is already in homeroom #{pscl.classroom.name}")
    end
  end
end
