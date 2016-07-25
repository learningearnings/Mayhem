load 'lib/sti/client.rb'
Spree::User.class_eval do
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :confirmed_at, :confirmation_code, :confirmation_sent_at, :email, :password, :password_confirmation, :remember_me, :username, :api_user
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :as => :admin
  
  belongs_to :person
  has_many :person_school_links, :through => :person
  has_many :schools, :through => :person_school_links

  after_save :set_recovery_password, :set_student_confirmed_at
  #after_create :set_parent_code, :set_parent_code , unless: Proc.new { self.person.type == "Parent" }

  before_validation :strip_whitespace

  def self.authenticate_with_school_id(username,password,school_id)
    return if username.blank? || password.blank?
    # Regular teacher or student
    # The select here is to fix a read only record issue.
    # http://stackoverflow.com/questions/639171/what-is-causing-this-activerecordreadonlyrecord-error
    user = Spree::User.select("spree_users.*").where("LOWER(spree_users.username) = ?", username.downcase)
      .joins(person: {person_school_links: :school})
      .where(person: {status: "active"}, schools: {status: "active"})
      .where(person_school_links: {school_id: school_id, status: "active"}).first

    # LEAdmin user
    user = Spree::User.select("spree_users.*").
      where(:username => username).joins(:person).
      merge(LeAdmin.status_active).first if user.nil?

    user = nil if user && user.api_user != false && !user.valid_password?(password)
    # If there is no user found from the traditional methods lets check the sti
    # api
    if user.nil? && school = School.where(:id => school_id).where("schools.district_guid IS NOT NULL AND schools.sti_id IS NOT NULL").first
      link_token = StiLinkToken.where(:district_guid => school.district_guid, status: 'active').first
      return unless link_token
      client = STI::Client.new(:base_url => link_token.api_url, :username => username, :password => password)
      session_information = client.session_information
      return if session_information.response.code == "401"
      sti_user_id = (session_information.parsed_response["StaffId"] || session_information.parsed_response["StudentId"])
      sti_person = Person.where(:district_guid => school.district_guid, :sti_id => sti_user_id).first
      sti_person = nil unless sti_person.present? && sti_person.schools.include?(school)
      return if sti_person.nil?
      return if sti_person.user.nil?
      user = Spree::User.find(sti_person.user.id, readonly: false)
      return if user.nil?
      user.api_user = true
      user.username = username
      user.save(:validate => false)
    end
    user
  end

  def self.admin_created?
    true
  end

  # after the redirect for token authentication
  # the token should be killed
  def after_token_authentication
    self.authentication_token = nil
    self.save
  end

  def generate_auth_token_with_school_id(school_id)
    payload = {
      user_id: self.id,
      school_id: school_id
    }
    AuthToken.encode(payload)
  end

  protected
  def strip_whitespace
    self.username = self.username.strip unless self.username.blank?
    self.email = self.email.strip unless self.email.blank?
  end

  def set_recovery_password
    if person && password
      person.update_attribute(:recovery_password, password)
    end
  end

  def set_parent_code
    SecureRandom.hex(16).tap do |random_token|
      update_attributes parent_token: random_token
      Rails.logger.info("Set new token for parent #{ id }")
    end
  end
  
  def set_student_confirmed_at
    if person and person.type == "Student" and self.confirmed_at.nil?
      self.confirmed_at = Time.now
      self.save
    end
  end

  def email_required?
    false
  end

  def password_required?
    api_user? ? false : super
  end
end
