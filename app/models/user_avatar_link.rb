class UserAvatarLink < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :avatar_id

  attr_accessible :avatar_id, :user_id
  belongs_to :user, :class_name => Spree::User
  belongs_to :avatar

end
