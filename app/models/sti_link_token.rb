class StiLinkToken < ActiveRecord::Base
  attr_accessible :api_url, :district_guid, :link_key, :username, :password, :status
  attr_accessible :api_url, :district_guid, :link_key, :username, :password, :status, as: :admin
end
