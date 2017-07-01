require "basic_statuses"

class School < ActiveRecord::Base
  include BasicStatuses

  before_create :set_status_to_active
  GRADES = ["K", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
  GRADE_NAMES = ["Kindergarten", "1st Grade", "2nd Grade", "3rd Grade", "4th Grade", "5th Grade", "6th Grade", "7th Grade", "8th Grade", "9th Grade", "10th Grade", "11th Grade", "12th Grade"]

  belongs_to :state
  has_many :addresses, :as => :addressable
  has_many :classrooms
  has_many :foods, :through => :food_school_links
  has_many :food_school_links
  has_many :person_school_links
  has_many :school_filter_links, :inverse_of => :schools
  has_many :filters, :through => :school_filter_links
  has_many :auctions, :through => :auction_school_links
  has_many :auction_school_links
  has_many :otu_code_categories
  has_one  :our_sponsor_post
  has_many :school_credits
  has_many :teacher_credits
  has_many :school_product_links
  has_many :products, :through => :school_product_links, :class_name => "Spree::Product", :source => :spree_product
  has_many :audit_logs, :as => :log_event

  has_many :reward_exclusions

  attr_accessible :ad_profile, :distribution_model, :gmt_offset,:address,:store_subdomain, :city, :state_id, :zip, :address1, :address2, :can_revoke_credits,
                  :logo, :logo_name, :logo_uid,:printed_credit_logo, :mascot_name, :max_grade, :min_grade, :name,
                  :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone, :legacy_school_id, :sti_id, :district_guid,
                  :weekly_perfect_attendance_amount, :monthly_perfect_attendance_amount, :weekly_no_tardies_amount, :monthly_no_tardies_amount,
                  :weekly_no_infractions_amount, :monthly_no_infractions_amount, :credits_scope, :credits_type, :admin_credit_percent

  attr_accessible :ad_profile, :distribution_model, :gmt_offset,:address, :city, :state_id, :zip, :address1, :address2, :can_revoke_credits,
                  :logo, :logo_name, :logo_uid, :printed_credit_logo, :mascot_name, :max_grade, :min_grade, :name,:store_subdomain,:credits_scope, :credits_type,
                  :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone, :created_at, :admin_credit_percent, :as => :admin

  image_accessor :logo
  image_accessor :printed_credit_logo

  validates_presence_of :name, :city, :state_id, :zip, :address1
  validates_uniqueness_of :sti_uuid, allow_blank: true
  validates_inclusion_of :admin_credit_percent, :in => 5..100, :message => " should be between 5 to 100"
  after_save :create_spree_store
  after_create :ensure_accounts
  after_create :set_default_subdomain
  after_create :set_default_distribution_model

  before_create :set_status_to_active

  scope :for_states, lambda {|states| joins(:addresses => :state).where("states.id" => Array(states).map(&:id) ) }
  scope :has_automatic_credit_amounts, lambda {
    where(arel_table[:weekly_perfect_attendance_amount].not_eq(nil).or(
    arel_table[:monthly_perfect_attendance_amount].not_eq(nil)).or(
    arel_table[:weekly_no_tardies_amount].not_eq(nil)).or(
    arel_table[:monthly_no_tardies_amount].not_eq(nil)).or(
    arel_table[:weekly_no_infractions_amount].not_eq(nil)).or(
    arel_table[:monthly_no_infractions_amount].not_eq(nil)))
  }
  scope :has_weekly_automatic_credit_amounts, lambda {
    where(arel_table[:weekly_perfect_attendance_amount].not_eq(nil).or(
    arel_table[:weekly_no_tardies_amount].not_eq(nil)).or(
    arel_table[:weekly_no_infractions_amount].not_eq(nil)))
  }
  scope :has_monthly_automatic_credit_amounts, lambda {
    where(arel_table[:monthly_perfect_attendance_amount].not_eq(nil).or(
    arel_table[:monthly_no_tardies_amount].not_eq(nil)).or(
    arel_table[:monthly_no_infractions_amount].not_eq(nil)))
  }
  scope :inow_schools, lambda { where(arel_table[:district_guid].not_eq(nil)) }

  def is_inow?
    !!district_guid
  end

  def is_inow?
    !!district_guid
  end

  def set_status_to_active
    self.status = 'active' # Students should default to active
  end

  def address=(newaddress)
    addresses << newaddress
  end

  def address
    addr = ""
    addr << "#{address1}<br>"
    addr << "#{address2}<br>" if address2.present?
    addr << "#{city}, "
    addr << state.name
    addr << " #{zip}"
    addr.html_safe
  end

  def download_s3_logo
    file = open(self.logo.remote_url)
    file.path if file
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
    #hack to cover us for schools that were created without default min/max grades
    if self.min_grade == nil
      self.min_grade = "0"
    end
    if self.max_grade == nil
      self.max_grade = "12"
    end
    self.min_grade..self.max_grade
  end

  def grades
    @grades ||= self.grade_range.collect do |g| [g,School::GRADE_NAMES[g]] end
  end

  def grades_name_first
    @grades_name_first ||= self.grade_range.collect do |g| [School::GRADE_NAMES[g], g] end
  end

  def self.grade_range
    0..12
  end

  def self.grades
    self.grade_range.collect do |g| [School::GRADE_NAMES[g], g] end
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
    (self.students.recent + self.students.recently_logged_in).uniq
  end

  # End Relationships

  def main_account_name
    "SCHOOL#{id} MAIN"
  end
  
  def bonus_account_name
    "SCHOOL#{id} BONUS"
  end

  def store_account_name
    "SCHOOL#{id} STORE"
  end

  def main_account
    @school_main_account ||= Plutus::Asset.find_by_name main_account_name
  end
  
  def bonus_account
    @school_bonus_account ||= Plutus::Asset.find_by_name bonus_account_name
    if !@school_bonus_account
      @school_bonus_account = Plutus::Asset.new
      @school_bonus_account.name = bonus_account_name
      @school_bonus_account.save
    end
    @school_bonus_account
    
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
    return "" if state == nil
    [name, city, state.name].join(", ")
  end

  def first_address
    addresses.first
  end

  def distributing_teachers
    @distributing_teachers = self.teachers.includes(:person_school_links).where(" person_school_links.can_distribute_rewards = 't' ")
    @distributing_teachers = self.school_admins if @distributing_teachers.blank?
    @distributing_teachers = self.teachers if @distributing_teachers.blank?
    @distributing_teachers.compact
  end

  def synced?
    district_guid.present? && sti_id.present?
  end

  def sponsor_post
    our_sponsor_post || build_our_sponsor_post
  end

  private
  def ensure_accounts
    main_account || Plutus::Asset.create(name: main_account_name)
    store_account || Plutus::Asset.create(name: store_account_name)
  end

  def set_status_to_active
    self.status = 'active' # Teachers should default to active
  end

  def set_default_subdomain
    if store_subdomain.nil?
      address_state_abbr = state.abbr.to_s.downcase
      update_attribute(:store_subdomain, "#{address_state_abbr}#{self.id.to_s}")
    end
  end
  
  def set_default_distribution_model
    if distribution_model.nil?
      update_attribute(:distribution_model,'Centralized')
    end
  end
end
