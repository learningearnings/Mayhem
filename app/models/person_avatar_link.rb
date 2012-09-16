class PersonAvatarLink < ActiveRecord::Base
  validates_presence_of :person_id
  validates_presence_of :avatar_id

  attr_accessible :avatar_id, :person_id
  belongs_to :person
  belongs_to :avatar

end
