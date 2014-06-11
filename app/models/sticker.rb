class Sticker < ActiveRecord::Base
  image_accessor :image
  belongs_to :school

  has_many :sticker_purchases
end
