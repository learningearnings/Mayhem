class Food < ActiveRecord::Base
  image_accessor :image

  attr_accessible :name, :image_uid

  has_many :food_schools, :through => :food_school_links
  has_many :food_school_links

  def to_s
    name
  end

end
