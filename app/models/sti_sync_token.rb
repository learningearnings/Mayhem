class StiSyncToken < ActiveRecord::Base
  attr_accessible :api_url, :district_guid, :sync_key, :username, :password
end
