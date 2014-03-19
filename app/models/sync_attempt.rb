class SyncAttempt < ActiveRecord::Base
  attr_accessible :district_guid, :status, :sync_type
end
