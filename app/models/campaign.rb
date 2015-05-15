class Campaign < ActiveRecord::Base
  has_many :campaign_views
  attr_accessible :name, :description 
   
end