class Sticker < ActiveRecord::Base
  image_accessor :image
  belongs_to :school

  has_many :sticker_purchases

  attr_accessible :image, :min_grade, :max_grade, :school_id, :as => [:default, :admin]
end
