require "basic_statuses"

class School < ActiveRecord::Base
  include BasicStatuses

  GRADES = ["K", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
  GRADE_NAMES = ["Kindergarten", "1st Grade", "2nd Grade", "3rd Grade", "4th Grade", "5th Grade", "6th Grade", "7th Grade", "8th Grade", "9th Grade", "10th Grade", "11th Grade", "12th Grade"]
  has_many :addresses, :as => :addressable
  has_many :classrooms
  has_many :foods, :through => :food_school_links
  has_many :food_school_links
  has_many :person_school_links
  has_many :school_filter_links, :inverse_of => :schools
  has_many :filters, :through => :school_filter_links

  has_many :reward_distributors, :through => :person_school_links, :include => :teacher

  attr_accessible :ad_profile, :distribution_model, :gmt_offset,:address,:store_subdomain,
                  :logo_name, :logo_uid, :mascot_name, :max_grade, :min_grade, :name,
                  :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone

  attr_accessible :ad_profile, :distribution_model, :gmt_offset,:address,
                  :logo_name, :logo_uid, :mascot_name, :max_grade, :min_grade, :name,:store_subdomain,
                  :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone, :created_at, :as => :admin


  validates_presence_of :name
  validates_presence_of :addresses

  after_save :create_spree_store
  after_create :ensure_accounts
  after_create :set_default_subdomain

  scope :for_states, lambda {|states| joins(:addresses => :state).where("states.id" => Array(states).map(&:id) ) }

  def address=(newaddress)
    addresses << newaddress
  end

  def create_spree_store
    if Rails.env.development?
      port = ':3000'
      host = '.lvh.me'
    else
      port = ''
      host = '.mayhemstaging.lemirror.com'
    end
    unless Spree::Store.find_by_code(self.store_subdomain)
      Spree::Store.create(code: self.store_subdomain, name: self.name, default: false, email: "theteam@learningearnings.com", domains: "#{self.store_subdomain}#{host}#{port}")
    end
  end

  def store
    Spree::Store.where(code: store_subdomain).first
  end

  def grade_range
    self.min_grade..self.max_grade
  end

  def grades
    self.grade_range.collect do |g| [g,School::GRADE_NAMES[g]] end
  end

  # Relationships
  def person_school_links(status = :status_active)
    PersonSchoolLink.where(school_id: self.id).send(status)
  end
  def persons(status = :status_active)
    Person.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end
  def parents(status = :status_active)
    Parent.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end
  def teachers(status = :status_active)
    Teacher.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end
  def school_admins(status = :status_active)
    SchoolAdmin.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end
  def students(status = :status_active)
    Student.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end
  def active_students
    (self.students.recent + self.students.logged).uniq
  end

  # End Relationships

  def main_account_name
    "SCHOOL#{id} MAIN"
  end

  def store_account_name
    "SCHOOL#{id} STORE"
  end

  def main_account
    @school_main_account ||= Plutus::Asset.find_by_name main_account_name
  end

  def store_account
    @school_store_account ||= Plutus::Asset.find_by_name store_account_name
  end

  def balance
    main_account.balance
  end

  def number_of_active_students
    active_students.count
  end

  def number_of_participating_teachers
    teachers.count
  end

  def to_s
    name
  end

  def name_and_location
    [name, first_address.try(:city_and_state)].join(", ")
  end

  def first_address
    addresses.first
  end

  def distributing_teachers
    @distributing_teachers = self.reward_distributors.includes(:teacher).collect {|rd| rd.teacher }
    @distributing_teachers = self.school_admins if @distributing_teachers.blank?
    @distributing_teachers = self.teachers if @distributing_teachers.blank?
    @distributing_teachers
  end

  private
  def ensure_accounts
    main_account || Plutus::Asset.create(name: main_account_name)
    store_account || Plutus::Asset.create(name: store_account_name)
  end

  def set_default_subdomain
    if store_subdomain.nil?
      address_state_abbr = addresses.first.try(:state).try(:abbr).to_s.downcase
      update_attribute(:store_subdomain, "#{address_state_abbr}#{self.id.to_s}")
    end
  end
end
