class Avatar < ActiveRecord::Base
  image_accessor :image
  attr_accessible :description, :image, :image_name, :image_uid
  attr_accessible :description, :image, :image_name, :image_uid, :as => :admin
  has_many :people, :through => :person_avatar_links
end
