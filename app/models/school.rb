class School < ActiveRecord::Base

  has_many :person_school_links, :conditions => {:status => 'active'}
  has_many :parents, :through => :person_school_links, :source => :person, :class_name => 'Parent', :conditions => {:status => 'active'}
  has_many :teachers, :through => :person_school_links, :source => :person, :class_name => 'Teacher', :conditions => {:status => 'active'}
  has_many :students, :through => :person_school_links, :source => :person, :class_name => 'Student', :conditions => {:status => 'active'}
  has_many :school_admins, :through => :person_school_links, :source => :person, :class_name => 'SchoolAdmin', :conditions => {:status => 'active'}

  attr_accessible :ad_profile, :school_address_id, :distribution_model, :gmt_offset,
                  :logo_name, :logo_uid, :mascot_name, :max_grade, :min_grade, :name,
                  :school_demo, :school_mail_to, :school_phone, :school_type_id, :status, :timezone

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create :ensure_account

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
