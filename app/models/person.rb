require "basic_statuses"
require 'macro_reflection_relation_facade'

class Person < ActiveRecord::Base
  include BasicStatuses
  has_one  :user, :class_name => Spree::User, :autosave => true

  scope :active, where({people: {status: 'active'}})

  ## Only useful for the scopes below with_transactions...
  ## Don't use for anything else
  ## Need to get rid of spree_users anyway...
  ##
  has_one  :spree_user, :class_name => 'Spree::User'

  has_many :auctions
  has_many :posts
  has_many :delayed_reports
  has_many :sent_messages, class_name: "Message", foreign_key: "from_id"
  has_many :received_messages, class_name: "Message", foreign_key: "to_id"
  has_many :person_school_links
  has_many :person_account_links, :through => :person_school_links
  has_many :plutus_accounts, :through => :person_account_links, :class_name => 'Plutus::Account'
  has_many :plutus_amounts, :through => :plutus_accounts, :class_name => 'Plutus::Amount', :source => :amounts
  has_many :plutus_transactions, :through => :plutus_amounts, :class_name => 'Plutus::Transaction', :source => :transaction
  has_many :allperson_school_links, :class_name => 'PersonSchoolLink'
  has_many :allschools, :class_name => 'School', :through => :allperson_school_links, :order => 'id desc', :source => :school
  has_many :person_school_classroom_links, :through => :person_school_links
  has_many :person_buck_batch_links
  has_many :person_avatar_links, :autosave => :true, :order => 'created_at desc, id desc'
  has_many :avatars, :through => :person_avatar_links, :order => "#{PersonAvatarLink.table_name}.created_at desc ,#{PersonAvatarLink.table_name}.id desc"
  has_many :interactions
  has_many :code_entry_failures

  has_many :spree_product_person_links
  has_many :products, :through => :spree_product_person_links

  validates_uniqueness_of :sti_uuid, allow_blank: true

  has_many :foods, :through => :food_person_links
  has_many :food_person_links

  has_many :food_fight_players

  has_many :votes

  accepts_nested_attributes_for :user

  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id, :user, :gender, :salutation, :school, :username, :email, :user_attributes, :recovery_password, :password, :sti_id, :district_guid, :password_confirmation, :type, :can_distribute_credits, :student_id, :parents_attributes
  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id, :user, :gender, :salutation, :status,:username,:email, :password,  :password_confirmation, :type,:created_at,:user_attributes, :recovery_password,:person_school_links, :district_guid, :sti_id, :as => :admin
  validates_presence_of :first_name, :last_name

  delegate :email, :email=, :username, :username=, :password=, :password, :password_confirmation=, :password_confirmation, :last_sign_in_at, :last_sign_in_at=, to: :user, allow_nil: true

  scope :not_ignored, lambda { |school_id| joins(:person_school_links).where(person_school_links: { school_id: school_id, ignore: false })}
  scope :ignored, lambda { |school_id| joins(:person_school_links).where(person_school_links: { school_id: school_id, ignore: true })}
  scope :for_schools, lambda {|schools| joins(:person_school_links).where(:person_school_links => {:school_id => schools})}
  scope :with_plutus_amounts, joins(:person_school_links => [:person_account_links => [:account => [:amounts => [:transaction]]]]).merge(PersonAccountLink.with_main_account).group(:people => :id)
  scope :with_transactions_between, lambda { |startdate,enddate|
    joins(:person_school_links => [:person_account_links => [:account => [:amounts => [:transaction]]]])
      .where(:person_school_links => {:person_account_links => {:account => {:amounts => {:transaction => {:created_at => (startdate..enddate)}}}}})
      .joins(:spree_user)
      .merge(PersonAccountLink.with_main_account)
      .group([:people => :id, :spree_users => :id]) }
  scope :with_transactions_since, lambda { |startdate| with_transactions_between(startdate,1.second.from_now) }
  scope :with_username, lambda{|username| joins(:spree_user).where("spree_users.username = ?", username) }
  scope :with_email,    lambda{|email| joins(:spree_user).where("spree_users.email = ?", email) }
  scope :recently_logged_in, lambda{ where('last_sign_in_at >= ?', (Time.now - 1.month)).joins(:user) }
  scope :logged_in_between, lambda { |start_date, end_date| joins(:user).where('last_sign_in_at >= ? AND last_sign_in_at <= ?', start_date, end_date) }
  scope :recently_created, lambda { where(self.arel_table[:created_at].gt Time.now - 1.month) }
  scope :created_between, lambda { |start_date, end_date| where(self.arel_table[:created_at].gteq(start_date)).where(self.arel_table[:created_at].lteq(end_date))}
  scope :created_before, lambda { |end_date| where(self.arel_table[:created_at].lteq(end_date))}
  scope :person_with_classroom, lambda {|classroom| joins(:person_school_classroom_links).where("person_school_classroom_links.classroom_id = ?", classroom)}
  scope :with_credits_between, lambda {|start_date, end_date| where("otu_codes.created_at >= ? AND otu_codes.created_at <= ?", start_date, end_date) }
  scope :selected_students, lambda {|selected_students| where("people.id IN (?)", selected_students).order("first_name ASC")}
  before_save :ensure_spree_user
  before_validation :strip_whitespace
  after_destroy :delete_user

  def otu_code_categories(current_school_id)
    arel_table = OtuCodeCategory.arel_table
    occ = OtuCodeCategory.where(
      arel_table[:school_id].eq(current_school_id).and(
        arel_table[:person_id].eq(self.id).or(
          arel_table[:person_id].eq(nil)
        )
      )
    )
    occ.sort { | x, y | x.name.downcase <=> y.name.downcase } if occ
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
    links = FoodPersonLink.find_all_by_thrown_by_id(self.id)
    links.sort_by{|x| x.food_id}.uniq{|x| x.food_id}.map{|x| x.food}.first(3)
  end

  def favorite_people
    links = FoodPersonLink.find_all_by_thrown_by_id(self.id)
    links.sort_by{|x| x.person_id}.uniq{|x| x.person_id}.map{|x| x.person}.first(3)
  end

  def food_schools
    School.joins(:person_food_school_links).where(person_food_school_links: { id: person_food_school_links.map(&:id) })
  end

  # Relationships

  def ensure_spree_user
    self.user = Spree::User.new unless user
  end

  def delete_user
    self.user.delete
  end

  def person_school_classroom_links(status = :status_active)
    PersonSchoolClassroomLink.joins(:person_school_link).where(person_school_link: { id: person_school_links(status).map(&:id) }).send(status)
  end

  def homeroom
    person_school_classroom_links.where(:homeroom => true).map(&:classroom).first
  end

  def schools(status = :status_active)
    MacroReflectionRelationFacade.new(School.joins(:person_school_links).where(person_school_links: { id: person_school_links(status).map(&:id) }).send(status).order('created_at desc'))
  end

  def school status = :status_active
    schools(status).first
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
  
  def person_classroom
    Person.joins(person_school_links: [{ person_school_classroom_links: :classroom }]).select("classrooms.id as classroom_id, classrooms.name as class_name").where("people.id = ?", self.id).order("classrooms.name ASC")
  end

  def person_classroom_name
    person_classroom.map{|c| c.class_name}
  end
  # End Relationships

  # Only return the classrooms for the given school
  def classrooms_for_school(school)
    classrooms.order(:name).select{|c| c.school == school}
  end

  def full_name
    self.first_name + ' ' + self.last_name
  end

  alias_method :name, :full_name
  alias_method :to_s, :full_name

  def name_last_first
    self.last_name + ', ' + self.first_name
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

  def food_fight_matches
    food_fight_players.map{|x| x.match if x.match && x.match.active}.compact
  end

  def food_fight_wins
    food_fight_players.select{|x| x.winner?}
  end

  def orders
    user.orders
  end

  def assignable_classrooms_for_school(school)
    if school.synced?
      classrooms.not_synced
    else
      classrooms
    end
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
  
   def strip_whitespace
    self.first_name = self.first_name.strip unless self.first_name.blank?
    self.last_name = self.last_name.strip unless self.last_name.blank?
   end
end
