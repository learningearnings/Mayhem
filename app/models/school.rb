require "basic_statuses"

class School < ActiveRecord::Base
  include BasicStatuses
  has_many :addresses, :as => :addressable
  has_many :classrooms
  has_many :foods, :through => :food_school_links
  has_many :food_school_links
  has_many :person_school_links
  has_many :school_filter_links, :inverse_of => :schools
  has_many :filters, :through => :school_filter_links
  after_save :create_spree_store

  attr_accessible :ad_profile, :distribution_model, :gmt_offset,
                  :logo_name, :logo_uid, :mascot_name, :max_grade, :min_grade, :name,
                  :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create :ensure_accounts

  def create_spree_store
    if Rails.env.development?
      port = ':3000'
      host = '.lvh.me'
    else
      port = ''
      host = '.mayhem.lemirror.com'
    end
    unless Spree::Store.find_by_code(self.store_subdomain)
      Spree::Store.create(code: self.store_subdomain, name: self.name, default: false, email: "theteam@learningearnings.com", domains: "#{self.store_subdomain}#{host}#{port}")
    end
  end

  def store
    Spree::Store.where(code: store_subdomain).first
  end

  # Relationships
  def person_school_links(status = :status_active)
    PersonSchoolLink.where(school_id: self.id).send(status)
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
    Plutus::Asset.find_by_name main_account_name
  end

  def store_account
    Plutus::Asset.find_by_name store_account_name
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

  def store_subdomain
    self.id.to_s
  end

  private
  def ensure_accounts
    main_account || Plutus::Asset.create(name: main_account_name)
    store_account || Plutus::Asset.create(name: store_account_name)
  end
end
