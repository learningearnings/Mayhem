require 'basic_statuses'
require 'macro_reflection_relation_facade'

class PersonSchoolLink < ActiveRecord::Base
  state_machine :status, :initial => :active do
  end

  scope :not_this_id, where("id != #{@id}")
  include BasicStatuses

  after_create :setup_accounts

  belongs_to :school
  belongs_to :person

  has_many :person_school_classroom_links, :inverse_of => :person_school_link
  has_many :classrooms, :through => :person_school_classroom_links, :source => :classroom, :inverse_of => :classroom

  attr_accessible :person_id, :school_id, :status
  validates_presence_of :person_id, :school_id
  validate :validate_unique_with_status

  def link(d)
    if d && d.is_a?(Hash)
      self.school_id = d[:school_id] if d[:school_id]
      self.person_id = d[:person_id] if d[:person_id]
      self.school_id = d[:school].id if d[:school]
      self.person_id = d[:person].id if d[:person]
    end
  end

  # Relationships
  def person_school_classroom_links(status = :status_active)
    MacroReflectionRelationFacade.new(PersonSchoolClassroomLink.where(person_school_link_id: self.id).send(status))
  end

  def classrooms(status = :status_active)
    Classroom.joins(:person_school_classroom_links).merge(person_school_classroom_links(status)).send(status)
  end
  # End Relationships

  def setup_accounts
    if person.is_a?(Teacher) || person.is_a?(SchoolAdmin)
      person.setup_accounts(school)
    end
  end

  ################### Validations ########################

  #
  # There can be an unlimited number of person_id -> school_id combinations that *don't* have status == "active"
  # but only one active one for a person -> school combination
  def validate_unique_with_status
    psl = PersonSchoolLink.where(:person_id => self.person_id, :school_id => self.school_id).status_active
    if self.id
      psl = psl.where("id != #{self.id}")
    end
    if psl.length > 0
      errors.add(:status, "Person is already associated with this school")
    end
  end
end

