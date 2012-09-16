Spree::User.class_eval do
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  belongs_to :person
  has_many :person_school_links, :through => :person
  has_many :schools, :through => :person_school_links

  def self.authenticate_with_school_id(username,password,school_id)
    if username.blank? || password.blank? || school_id.blank?
      nil
    else
      encrypted_password = ::BCrypt::Password.create("#{password}#{self.pepper}", :cost => self.stretches).to_s
      u = Spree::User.where(:username => username).joins(:person).merge(Person.status_active).joins(:schools).merge(School.status_active).where('schools.id = ?',school_id).first
      if u.nil?
        u = Spree::User.where(:username => username).joins(:person).merge(LeAdmin.status_active).first
      end
    end
    if u.nil?
      nil
    elsif u.valid_password?(password)
      Spree::User.find(u.id)
    else
      nil
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
