class Avatar < ActiveRecord::Base
  image_accessor :image
  attr_accessible :description, :image, :image_name, :image_uid
end
