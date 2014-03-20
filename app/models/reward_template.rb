class RewardTemplate < ActiveRecord::Base
  attr_accessible :description, :name, :price
  attr_accessible :name, :description, :price, :as => :admin
end
