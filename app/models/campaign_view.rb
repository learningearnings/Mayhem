class CampaignView < ActiveRecord::Base
  belongs_to :campaign
  attr_accessible :person_id, :campaign_id
  
end