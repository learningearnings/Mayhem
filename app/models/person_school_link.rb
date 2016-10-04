require 'basic_statuses'
require 'macro_reflection_relation_facade'

class PersonSchoolLink < ActiveRecord::Base
  state_machine :status, :initial => :active do
    event :deactivate do
      transition :active => :inactive
    end
  end

  scope :not_this_id, where("id != #{@id}")
  include BasicStatuses

  after_create :setup_accounts
  attr_accessor :skip_onboard_credits

  belongs_to :school
  belongs_to :person
  has_many :person_school_classroom_links, :inverse_of => :person_school_link
  has_many :audit_logs, :as => :log_event
  has_many :classrooms, :through => :person_school_classroom_links, :source => :classroom, :inverse_of => :classroom
  has_many :person_account_links
  has_many :plutus_accounts, :through => :person_account_links, :class_name => 'Plutus::Account'
  has_many :otu_codes

  attr_accessible :person_id, :school_id, :status, :person, :school, :can_distribute_credits
  validates_presence_of :person_id, :school_id
  validate :validate_unique_with_status
  validate :username_taken?

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
    if person.is_a?(Student) && !skip_onboard_credits
      StudentOnboardCreditWorker.perform_async(school.id)
    end
    connect_plutus_accounts unless person.is_a? LeAdmin
  end

  # Loop through all the schools, find the accounts and hook them up to the Student/Teacher/SchoolAdmin
  # Not valid for LE Admins
  def connect_plutus_accounts
    return if self.person == nil
    return if school == nil
    return if self.person.class == Person
    main_account_id = self.person.main_account(school).id
    accounts = self.person.accounts(school).collect {|a| a.id}
    PersonAccountLink.where(:plutus_account_id => accounts).each do |pal|
      pal.destroy
    end
    accounts.each do |a|
      pal = PersonAccountLink.create(person_school_link_id: self.id, plutus_account_id: a, is_main_account: a == main_account_id)
    end
  end

  ################### Validations ########################
  def username_taken?
    errors.add(:status, "Person must be present") and return unless person && person.user.username
    return if status == "inactive"
    ignored_ids = [person.id]
    @students = school.students.where("people.id NOT IN (?)", ignored_ids)
    @teachers = school.students.where("people.id NOT IN (?)", ignored_ids)
    if @teachers.with_username(person.user.username).present?
      errors.add(:status, "Username already assigned for this school.") and return
    end
    if @students.with_username(person.user.username).present?
      errors.add(:status, "Username already assigned for this school.") and return
    end
  end

  # There can be an unlimited number of person_id -> school_id combinations that *don't* have status == "active"
  # but only one active one for a person -> school combination
  def validate_unique_with_status
    psl = PersonSchoolLink.where(:person_id => self.person_id, :school_id => self.school_id).status_active
    if self.id
      psl = psl.where("id != #{self.id}")
    end
    if psl.length > 0
      errors.add(:status, "Username already associated with this school.")
    end
  end
end
