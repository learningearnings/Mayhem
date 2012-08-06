class UserAvatarLink < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :avatar_id

end
