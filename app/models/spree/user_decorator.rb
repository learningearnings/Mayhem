Spree::User.class_eval do
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  belongs_to :person
  has_one :user_avatar_link
  has_one :avatar, :through => :user_avatar_link
end
