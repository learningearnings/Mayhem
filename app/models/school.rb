require "basic_statuses"

class School < ActiveRecord::Base
  include BasicStatuses
  has_many :addresses, :as => :addressable

  has_many :person_school_links

  attr_accessible :ad_profile, :distribution_model, :gmt_offset,
                  :logo_name, :logo_uid, :mascot_name, :max_grade, :min_grade, :name,
                  :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create :ensure_account

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
  # End Relationships


  def account_name
    "SCHOOL#{name}"
  end

  def account
    Plutus::Asset.find_by_name account_name
  end

  def balance
    account.balance
  end

  private
  def ensure_account
    account || Plutus::Asset.create(name: account_name)
  end
end
