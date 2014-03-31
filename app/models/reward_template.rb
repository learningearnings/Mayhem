require 'dragonfly/rails/images'
class RewardTemplate < ActiveRecord::Base
  include PgSearch

  image_accessor :image

  attr_accessible :description, :name, :price, :image, :image_uid, :min_grade, :max_grade
  attr_accessible :name, :description, :price, :image, :image_uid, :min_grade, :max_grade, :as => :admin

  scope :within_grade, lambda {|grade|  where("? BETWEEN min_grade AND max_grade", grade) }

   pg_search_scope :kinda_matching,
                   :against => [:name, :description],
                   :using => {
                     :tsearch => {:dictionary => "english"}
                   }
end
