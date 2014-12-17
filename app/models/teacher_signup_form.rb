class TeacherSignupForm
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :dob, :gender, :grade
  attr_accessor :email, :username, :password, :password_confirmation
  attr_accessor :name, :city, :state_id, :address1, :zip

  validates :first_name,            presence: true
  validates :last_name,             presence: true
  validates :email,                 presence: true
  validates :grade,                 presence: true
  validates :username,              presence: true
  validates :password,              presence: true
  validates :password_confirmation, presence: true
  validates :name,                  presence: true
  validates :city,                  presence: true
  validates :state_id,              presence: true
  validates :address1,              presence: true
  validates :zip,                   presence: true
  validate  :uniqueness_of_email
  validate  :uniqueness_of_school

  def initialize(attributes={})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Teacher")
  end

  def save
    person.assign_attributes(person_attributes, as: :admin)
    user.assign_attributes(user_attributes, as: :admin)
    school.assign_attributes(school_attributes, as: :admin)
    return false unless valid?
    if create_objects
      PersonSchoolLink.create(person_id: person.id, school_id: school.id, status: "active")
      true
    else
      false
    end
  end

  def person
    @person ||= Teacher.new
  end

  def user
    person.user ||= Spree::User.new
  end

  def school
    @school ||= School.new
  end

  def uniqueness_of_email
    if Spree::User.exists?(['LOWER(email) = LOWER(?)', email])
      errors.add(:email, "has already been used")
    end
  end

  def uniqueness_of_school
    if School.exists?(['LOWER(name) = LOWER(?) AND LOWER(city) = LOWER(?) AND state_id = ?', name, city, state_id])
      errors.add(:school, "is already registered")
    end
  end

  private

  def person_attributes
    { first_name: first_name, last_name: last_name, email: email, username: username, dob: dob, gender: gender, grade: grade }
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
      school.save!
      person.user.save!
    end
  end
  
end
