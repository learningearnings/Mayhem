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
  has_many :person_account_links
  has_many :plutus_accounts, :through => :person_account_links, :class_name => 'Plutus::Account'
  has_many :reward_distributors
  attr_accessible :person_id, :school_id, :status, :person, :school
  validates_presence_of :person_id, :school_id
  validate :validate_unique_with_status
  #validate :email_taken?
  validate :username_taken?

  def otu_links(person)
    OtuCode.last_30.where(:person_school_link_id => person.id)
  end

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
    connect_plutus_accounts unless person.is_a? LeAdmin
  end

  # Loop through all the schools, find the accounts and hook them up to the Student/Teacher/SchoolAdmin
  # Not valid for LE Admins
  def connect_plutus_accounts
    self.person.schools.each do |s|
      main_account_id = self.person.main_account(s).id
      accounts = self.person.accounts(s).collect {|a| a.id}
      PersonAccountLink.where(:plutus_account_id => accounts).each do |pal|
        pal.destroy
      end
      psl = self if self.school_id = s.id
      psl ||= PersonSchoolLink.find_or_create_by_person_id_and_school_id(self.person.id,s.id)
      accounts.each do |a|
        pal = PersonAccountLink.create(person_school_link_id: psl.id, plutus_account_id: a, is_main_account: a == main_account_id)
      end
    end
  end

  ################### Validations ########################
  def email_taken?
    errors.add(:status, "Person must be present") and return unless person && person.user.email.present?
    return if status == "inactive"
    if person.is_a?(Student)
      return false
    else
      if school.teachers.with_email(person.user.email).present?
        errors.add(:base, "Email already assigned for this school.")
      end
    end
  end

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

