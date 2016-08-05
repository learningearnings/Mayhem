class ParentSignupForm
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :dob, :gender, :relationship, :phone
  attr_accessor :email, :username, :password, :password_confirmation
  attr_accessor :name, :city, :state_id, :address1, :zip
  attr_accessor :sti_id  

  validates :first_name,            presence: true
  validates :last_name,             presence: true
  validates :email,                 presence: true, email: true
  validates :username,              presence: true
  validates :password,              presence: true
  validates :password_confirmation, presence: true
  validates :relationship,          presence: true
  validates :phone,                 presence: true
  #validates :city,                  presence: true
  #validates :state_id,              presence: true
  #validates :address1,              presence: true
  #validates :zip,                   presence: true
  validate  :uniqueness_of_email
  validate  :password_matches_confirmation

  def initialize(attributes={})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Parent")
  end

  def save
    person.assign_attributes(person_attributes, as: :admin)
    user.assign_attributes(user_attributes, as: :admin)
    #school.assign_attributes(school_attributes, as: :admin) unless school_id
    return false unless valid?
    if create_objects
      user.person.status = "new"
      user.person.save
      #school.status = "new"
      #school.save
      true
    else
      false
    end
  end

  def person
    @person ||= Parent.new
  end

  def user
    person.user ||= Spree::User.new
  end

  # def school
  #   @school ||= School.new unless school_id
  #   @school = School.find(school_id) if school_id
  #   @school
  # end

  def uniqueness_of_email
    if Spree::User.exists?(['LOWER(email) = LOWER(?)', email])
      errors.add(:email, "has already been used")
    end
  end

  # def uniqueness_of_school
  #   if state_id != '' and !school_id
  #     if School.exists?(['LOWER(name) = LOWER(?) AND LOWER(city) = LOWER(?) AND state_id = ?', name, city, state_id])
  #       errors.add(:school, "is already registered")
  #     end
  #   end
  # end

  def password_matches_confirmation
    unless password.present? && password == password_confirmation
      errors.add(:password_confirmation, "doesn't match the password.")
    end
  end

  private

  def person_attributes
    { first_name: first_name, last_name: last_name, email: email, username: username, dob: dob, gender: gender, relationship: relationship, phone: phone}
  end

  def user_attributes
    { email: email, username: username, password: password, password_confirmation: password_confirmation }
  end

  def school_attributes
    { name: name, city: city, address1: address1, state_id: state_id, zip: zip }
  end

  def create_objects
    ActiveRecord::Base.transaction do
      person.save!
      #school.save!
      #PersonSchoolLink.create(person_id: person.id, school_id: school.id, status: "active")      
      #person.user.save!
    end
  end
  
end
