load 'lib/sti/client.rb'
Spree::User.class_eval do
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :api_user
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :as => :admin
  belongs_to :person
  has_many :person_school_links, :through => :person
  has_many :schools, :through => :person_school_links

  before_save :set_recovery_password

  def self.authenticate_with_school_id(username,password,school_id)
    return if username.blank? || password.blank? || school_id.blank?
    # Regular teacher or student
    user = Spree::User.select("spree_users.*").
      where("LOWER(spree_users.username) = ?", username.downcase).
      joins(:person).merge(Person.status_active).
      joins(:schools).merge(School.status_active).
      where('schools.id = ?',school_id).first

    # LEAdmin user
    user = Spree::User.select("spree_users.*").
      where(:username => username).joins(:person).
      merge(LeAdmin.status_active).first if user.nil?

    user = nil if user && user.api_user != false && !user.valid_password?(password)
    # If there is no user found from the traditional methods lets check the sti
    # api
    if user.nil? && school = School.where(:id => school_id).where("schools.district_guid IS NOT NULL AND schools.sti_id IS NOT NULL").first
      link_token = StiLinkToken.where(:district_guid => school.district_guid).first
      return unless link_token
      client = STI::Client.new(:base_url => link_token.api_url, :username => username, :password => password)
      session_information = client.session_information
      return if session_information.response.code == "401"
      sti_staff_id = session_information.parsed_response["StaffId"]
      sti_person = Teacher.where(:district_guid => school.district_guid, :sti_id => sti_staff_id).first
      sti_person = nil unless sti_person.schools.include?(school)
      return if sti_person.nil?
      user = sti_person.user
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

 protected
   def set_recovery_password
     if person && password
       person.update_attribute(:recovery_password, password)
     end
   end

   def email_required?
     false
   end

   def password_required?
     api_user? ? false : true
   end
end
