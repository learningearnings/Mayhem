class Sticker < ActiveRecord::Base
  image_accessor :image
  belongs_to :school
end
