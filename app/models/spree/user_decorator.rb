Spree::User.class_eval do
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :as => :admin

  belongs_to :person
  has_many :person_school_links, :through => :person
  has_many :schools, :through => :person_school_links

  def self.authenticate_with_school_id(username,password,school_id)
    return if username.blank? || password.blank? || school_id.blank?
    user = Spree::User.select("spree_users.*").
      where("LOWER(spree_users.username) = ?", username.downcase).
      joins(:person).merge(Person.status_active).
      joins(:schools).merge(School.status_active).
      where('schools.id = ?',school_id).first
    user = Spree::User.select("spree_users.*").where(:username => username).joins(:person).merge(LeAdmin.status_active).first if user.nil?
    if user && user.valid_password?(password)
      super_user = Spree::User.find(user.id)
      super_user.person.recovery_password = password and super_user.person.save if super_user && super_user.person
    end
    user || super_user
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
   def email_required?
     false
   end

   def password_required?
     api_user? ? false : true
   end
end
