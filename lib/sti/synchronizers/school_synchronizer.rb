module STI
  module Synchronizers
    class SchoolSynchronizer < BaseSynchronizer
      def execute!
        current_schools_for_district = School.where(district_guid: @district_guid).pluck(:sti_id)
        sti_school_ids = @data.map {|school| school["Id"]}
        # Schools that are synced in our DB but are no longer listed in the api
        (current_schools_for_district - sti_school_ids).each do |school_sti_id|
          school = School.where(:district_guid => @district_guid, :sti_id => school_sti_id).first
          if school
            school.deactivate

            sti_link_token = StiLinkToken.where(district_guid: @district_guid, status: 'active').first
            client = STI::Client.new(base_url: sti_link_token.api_url, username: sti_link_token.username, password: sti_link_token.password)
            client.set_school_synced(school.sti_id, false)
          end  
        end
        @data.each do |api_school|
          school = School.where(district_guid: @district_guid, sti_id: api_school["Id"]).first_or_initialize
          school.credits_scope = "School-Wide" unless school.credits_scope
          school.update_attributes(mapping(api_school))
          school.reload
          school.activate
        end
      end

      private

      def mapping(api_school)
        {
          name: api_school["Name"],
          address1: api_school["Address"] || "Blank",
          city: api_school["City"] || "Blank",
          state_id: (api_school["State"] ? (State.where(abbr: api_school["State"]).first.id) : (State.first.id)),
          zip: (api_school["PostalCode"] == nil or api_school["PostalCode"].strip.blank?) ? "35071" : (api_school["PostalCode"].strip),
          sti_id: api_school["Id"],
          min_grade: 1,
          max_grade: 12,
          district_guid: @district_guid
        }
      end
    end
  end
end
