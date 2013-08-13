require "basic_statuses"
require 'macro_reflection_relation_facade'

class Person < ActiveRecord::Base
  include BasicStatuses
  has_one  :user, :class_name => Spree::User, :autosave => true

  ## Only useful for the scopes below with_transactions...
  ## Don't use for anything else
  ## Need to get rid of spree_users anyway...
  ##
  has_one  :spree_user, :class_name => 'Spree::User'

  has_many :posts
  has_many :sent_messages, class_name: "Message", foreign_key: "from_id"
  has_many :received_messages, class_name: "Message", foreign_key: "to_id"
  has_many :person_school_links
  has_many :person_account_links, :through => :person_school_links
  has_many :plutus_accounts, :through => :person_account_links, :class_name => 'Plutus::Account'
  has_many :plutus_amounts, :through => :plutus_accounts, :class_name => 'Plutus::Amount', :source => :amounts
  has_many :plutus_transactions, :through => :plutus_amounts, :class_name => 'Plutus::Transaction', :source => :transaction
  has_many :allperson_school_links, :class_name => 'PersonSchoolLink'
  has_many :allschools, :class_name => 'School', :through => :allperson_school_links, :order => 'id desc', :source => :school
=begin
  has_one  :school, :through => :person_school_links, :order => "#{PersonSchoolLink.table_name}.created_at desc,#{PersonSchoolLink.table_name}.id desc"
=end
  has_many :person_school_classroom_links
  has_many :monikers
#  has_many :buck_batches, :through => :person_buck_batch_links
  has_many :person_buck_batch_links
  has_many :person_avatar_links, :autosave => :true, :order => 'created_at desc, id desc'
  has_many :avatars, :through => :person_avatar_links, :order => "#{PersonAvatarLink.table_name}.created_at desc ,#{PersonAvatarLink.table_name}.id desc"
  has_many :interactions

  has_many :spree_product_person_links
  has_many :products, :through => :spree_product_person_links

  has_many :votes


  scope :with_plutus_amounts, joins(:person_school_links => [:person_account_links => [:account => [:amounts => [:transaction]]]]).merge(PersonAccountLink.with_main_account).group(:people => :id)
  scope :with_transactions_between, lambda { |startdate,enddate|
    joins(:person_school_links => [:person_account_links => [:account => [:amounts => [:transaction]]]])
      .where(:person_school_links => {:person_account_links => {:account => {:amounts => {:transaction => {:created_at => (startdate..enddate)}}}}})
      .joins(:spree_user)
      .merge(PersonAccountLink.with_main_account)
      .group([:people => :id, :spree_users => :id]) }
  scope :with_transactions_since, lambda { |startdate| with_transactions_between(startdate,1.second.from_now) }

  # use the above like this (from rails c)
  # 1.9.3p327 :029 > sch = School.find(6)
  #   School Load (0.2ms)  SELECT "schools".* FROM "schools" WHERE "schools"."id" = $1 LIMIT 1  [["id", 6]]
  #  => #<School id: 6, name: "Caloosa Elementary", school_type_id: 1, min_grade: 0, max_grade: 12, school_phone: "239-574-3113", school_mail_to: "", logo_uid: nil, logo_name: nil, mascot_name: nil, school_demo: false, status: "active", timezone: "America/New_York", gmt_offset: #<BigDecimal:9c349f8,'-0.5E1',9(18)>, distribution_model: "Centralized", ad_profile: 821, created_at: "2010-07-01 05:00:00", updated_at: "2012-12-12 20:32:06", store_subdomain: "al6", legacy_school_id: 821> 
  # 1.9.3p327 :030 > student = sch.students.with_transactions_since(1.year.ago).group(:people => :id).select("people.*, sum(case when plutus_amounts.type = 'Plutus::DebitAmount' then plutus_amounts.amount else null end) - sum(case when plutus_amounts.type = 'Plutus::CreditAmount' then plutus_amounts.amount else null end) as activity,count(distinct plutus_transactions.id) as num_transactions").first
  #   Student Load (2.5ms)  SELECT people.*, sum(case when plutus_amounts.type = 'Plutus::DebitAmount' then plutus_amounts.amount else null end) - sum(case when plutus_amounts.type = 'Plutus::CreditAmount' then plutus_amounts.amount else null end) as activity,count(distinct plutus_transactions.id) as num_transactions FROM "people" INNER JOIN "person_school_links" ON "person_school_links"."person_id" = "people"."id" INNER JOIN "person_account_links" ON "person_account_links"."person_school_link_id" = "person_school_links"."id" INNER JOIN "plutus_accounts" ON "plutus_accounts"."id" = "person_account_links"."plutus_account_id" INNER JOIN "plutus_amounts" ON "plutus_amounts"."account_id" = "plutus_accounts"."id" INNER JOIN "plutus_transactions" ON "plutus_transactions"."id" = "plutus_amounts"."transaction_id" WHERE "people"."type" IN ('Student') AND "person_school_links"."school_id" = 6 AND "person_school_links"."status" = 'active' AND "people"."status" = 'active' AND "plutus_transactions"."created_at" BETWEEN '2011-12-14 15:42:02.165571' AND '2012-12-14 15:42:03.165881' AND "person_account_links"."is_main_account" = 't' GROUP BY "people"."id" LIMIT 1
  #  => #<Student id: 1191, first_name: "Morgan", last_name: "L", dob: nil, grade: 5, created_at: "2010-07-01 05:00:00", updated_at: "2012-12-12 20:32:10", type: "Student", status: "active", legacy_user_id: 168707, gender: "Female", salutation: nil, recovery_password: "i82much"> 
  # 1.9.3p327 :031 > student.activity
  #  => "1.0000000000" 
  # 1.9.3p327 :032 > student.num_transactions
  #  => "3" 
  # 1.9.3p327 :033 > 



  before_save :ensure_spree_user
  after_destroy :delete_user

  def name
    "#{first_name} #{last_name}"
  end

  def avatar
    avatars.first
  end

  def avatar=(new_avatar = nil)
    PersonAvatarLink.create(:avatar_id => new_avatar.id, :person_id => self.id) if new_avatar
  end

  def buck_batches(school)
    BuckBatch.where(:id => PersonBuckBatchLink.where(:person_school_link_id => self.person_school_links.where(school_id: school.id)).select(:buck_batch_id))
  end

  def favorite_foods
    links = FoodSchoolLink.find_all_by_person_id(self.id)
    links.sort_by{|x| x.food_id}.uniq{|x| x.food_id}.map{|x| x.food}.first(3)
  end

  def favorite_schools
    links = FoodSchoolLink.find_all_by_person_id(self.id)
    links.sort_by{|x| x.school_id}.uniq{|x| x.school_id}.map{|x| x.school}.first(3)
  end

  def food_schools
    School.joins(:person_food_school_links).where(person_food_school_links: { id: person_food_school_links.map(&:id) })
  end

  accepts_nested_attributes_for :user

  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id, :user, :moniker, :gender, :salutation, :school, :username, :user_attributes, :recovery_password
  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id, :user, :moniker, :gender, :salutation, :status,:username,:email, :password,  :password_confirmation, :type,:created_at,:user_attributes, :recovery_password,:person_school_links, :as => :admin
  validates_presence_of :first_name, :last_name

  delegate :email, :email=, :username, :username=, :password=, :password, :password_confirmation=, :password_confirmation, :last_sign_in_at, :last_sign_in_at=, to: :user, allow_nil: true

  # Relationships

  def ensure_spree_user
    self.user = Spree::User.new unless user
  end

  def delete_user
    self.user.delete
  end

  #Last approved moniker name
  def moniker
    moniker_record = monikers.approved.order("created_at DESC").first
    @moniker ||= moniker_record.nil? ? "" : moniker_record.moniker
  end

  def requested_moniker
    moniker_record = monikers.requested.order("created_at DESC").first
    @requested_moniker ||= moniker_record.nil? ? "" : moniker_record.moniker
  end

  def moniker= name
#    monikers.create(:moniker => name)
    monikers.new(:moniker => name)
  end

  def person_school_classroom_links(status = :status_active)
    PersonSchoolClassroomLink.joins(:person_school_link).where(person_school_link: { id: person_school_links(status).map(&:id) }).send(status)
  end

  def schools(status = :status_active)
    MacroReflectionRelationFacade.new(School.joins(:person_school_links).where(person_school_links: { id: person_school_links(status).map(&:id) }).send(status).order('created_at desc'))
  end

  def school(status = :status_active)
    MacroReflectionRelationFacade.new(School.joins(:person_school_links).where(person_school_links: { id: person_school_links(status).map(&:id) }).send(status).order('created_at desc').limit(1))
  end

  def person_school_links(status = :status_active)
    MacroReflectionRelationFacade.new(PersonSchoolLink.where(person_id: self.id).send(status))
  end

  def school=(my_new_school)
    if my_new_school.is_a? School
      psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(person_id: self.id, school_id: my_new_school.id)
    else
      psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(person_id: self.id, school_id: my_new_school)
    end
    psl.activate if psl
    self.person_school_links << psl
  end

  def classrooms(status = :status_active)
    Classroom.joins(:person_school_classroom_links).where(person_school_classroom_links: { id: person_school_classroom_links(status).map(&:id) }).send(status)
  end
  # End Relationships

  # Only return the classrooms for the given school
  def classrooms_for_school(school)
    classrooms.select{|c| c.school == school}
  end

  def full_name
    self.first_name + ' ' + self.last_name
  end

  def to_s
    full_name
  end

  def store_code
    nil
  end

  def rewards
    rewards = []
    user.orders.each do |order|
      order.line_items.each do |item|
        rewards.push(item) unless item.product.is_charity_reward?
      end
    end
    rewards
  end

  def orders
    user.orders
  end

  def charities
    charities = []
    user.orders.each do |order|
      order.line_items.each do |item|
        charities.push(item) if item.product.is_charity_reward?
      end
    end
    charities
  end

  # Allow sending a school or classroom to a person
  def <<(d)
    if d.is_a? School
      PersonSchoolLink.create(:school_id => d.id, :person_id => self.id)
    elsif d.is_a? Classroom
      psl = PersonSchoolLink.find_or_create_by_school_id_and_person_id(d.school_id, self.id)
      PersonSchoolClassroomLink.create(:classroom_id => d.id, :person_school_link_id => psl.id)
    end
  end
end
