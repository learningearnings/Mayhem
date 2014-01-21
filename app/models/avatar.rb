require 'dragonfly/rails/images'
class Avatar < ActiveRecord::Base
  image_accessor :image
  attr_accessible :description, :image, :image_name, :image_uid, :teacher_only
  attr_accessible :description, :image, :image_name, :image_uid, :teacher_only, :as => :admin
  has_many :people, :through => :person_avatar_links
  scope :for_teachers, where("teacher_only IS TRUE")
end
