class Food < ActiveRecord::Base
  image_accessor :image

  attr_accessible :name, :image_uid

  has_many :people, :through => :food_person_links
  has_many :food_person_links

  def to_s
    name
  end

end
