Spree::User.class_eval do
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  belongs_to :person
  has_many :person_school_links, :through => :person
  has_many :schools, :through => :person_school_links
  has_one :user_avatar_link
  has_one :avatar, :through => :user_avatar_link

  def self.authenticate_with_school_id(username,password,school_id)
    if username.blank? || password.blank? || school_id.blank?
      nil
    else
      encrypted_password = ::BCrypt::Password.create("#{password}#{self.pepper}", :cost => self.stretches).to_s
      binding.pry
      u = Spree::User.where(:username => username,:encrypted_password => encrypted_password).joins(:person).merge(Person.status_active).joins(:schools).merge(School.status_active).where('schools.id = ?',school_id).first.valid_password?
      if u.nil?
        u = Spree::User.where(:username => username,:encrypted_password => encrypted_password).joins(:person).merge(LeAdmin.status_active).first.valid_password?
      end
    end
    if u.nil?
      nil
    else
      Spree::User.find(u.id)
    end
  end


=begin
  def username
    if self.person
      self.person.username
    else
      self.email
    end
  end
=end 

  # after the redirect for token authentication
  # the token should be killed
  def after_token_authentication
    self.authentication_token = nil
    self.save
  end



end
