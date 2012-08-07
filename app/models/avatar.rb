class Avatar < ActiveRecord::Base
  image_accessor :image
  attr_accessible :description, :image, :image_name, :image_uid
  belongs_to :user, :class_name => Spree::User
end
