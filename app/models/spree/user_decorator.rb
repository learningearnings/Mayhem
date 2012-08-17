Spree::User.class_eval do
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  belongs_to :person
  has_one :user_avatar_link
  has_one :avatar, :through => :user_avatar_link


  # after the redirect for token authentication
  # the token should be killed
  def after_token_authentication
    self.authentication_token = nil
    self.save
  end



end
