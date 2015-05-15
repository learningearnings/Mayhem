class TeacherEmailForm
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :email, :person_id

  validates :email, presence: true, email: true
  validate  :uniqueness_of_email

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
    user.assign_attributes(user_attributes, as: :admin)
    return false unless valid?
    if create_objects
      true
    else
      false
    end

  end

  def person
    @person ||= Teacher.find(@person_id)
  end

  def user
    person.user ||= Spree::User.new
  end

  def uniqueness_of_email
    if Spree::User.exists?(['LOWER(email) = LOWER(?)', email])
      errors.add(:email, "has already been used")
      false
    end
  end


  private

  def user_attributes
    { email: email }
  end


  def create_objects
    ActiveRecord::Base.transaction do
      person.user.save!
    end
  end
  
end
