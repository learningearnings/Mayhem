class StiLinkToken < ActiveRecord::Base
  before_create :check_not_null_id
  
  attr_accessible :api_url, :district_guid, :link_key, :username, :password, :status
  attr_accessible :api_url, :district_guid, :link_key, :username, :password, :status, as: :admin
  
  private
    def check_not_null_id
      if self.id.blank?
        self.id = StiLinkToken.connection.select_value("select nextval('#{StiLinkToken.sequence_name}')").to_i
      end
    end
end
