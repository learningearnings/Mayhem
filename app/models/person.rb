require "basic_statuses"
require 'macro_reflection_relation_facade'

class Person < ActiveRecord::Base
  include BasicStatuses
  has_one  :user, :class_name => Spree::User, :autosave => true
  has_many :posts
  has_many :sent_messages, class_name: "Message", foreign_key: "from_id"
  has_many :received_messages, class_name: "Message", foreign_key: "to_id"
  has_many :person_school_links
  has_many :allperson_school_links, :class_name => 'PersonSchoolLink'
  has_many :allschools, :class_name => 'School', :through => :allperson_school_links, :order => 'id desc', :source => :school
=begin
  has_one  :school, :through => :person_school_links, :order => "#{PersonSchoolLink.table_name}.created_at desc,#{PersonSchoolLink.table_name}.id desc"
=end
  has_many :person_school_classroom_links
  has_many :monikers
  has_many :buck_batches, :through => :person_buck_batch_links
  has_many :person_buck_batch_links
  has_many :person_avatar_links, :autosave => :true, :order => 'created_at desc, id desc'
  has_many :avatars, :through => :person_avatar_links, :order => "#{PersonAvatarLink.table_name}.created_at desc ,#{PersonAvatarLink.table_name}.id desc"
  has_many :interactions

  has_many :spree_product_person_links
  has_many :products, :through => :spree_product_person_links

  before_save :ensure_spree_user

  def name
    "#{first_name} #{last_name}"
  end

  def avatar
    avatars.first
  end

  def avatar=(new_avatar = nil)
    avatars << new_avatar if new_avatar
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

  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id, :user, :moniker, :gender, :salutation, :school, :username, :user_attributes
  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id, :user, :moniker, :gender, :salutation, :status,:username,:email, :password_confirmation, :type,:created_at,:user_attributes, :as => :admin
  validates_presence_of :first_name, :last_name
#  delegate :email, :username , :password, :password_confirmation, to: :user
  delegate :email, :email=, :username, :username=, :password=, :password, :password_confirmation=, :password_confirmation, to: :user, allow_nil: true

  # Relationships

  def ensure_spree_user
    self.user = Spree::User.new unless user
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
      psl = PersonSchoolLink.new(person_id: self.id, school_id: my_new_school.id)
    else
      psl = PersonSchoolLink.new(person_id: self.id, school_id: my_new_school)
    end
    psl.save
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
