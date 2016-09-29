module STI
  module Updaters
    class StudentUpdater
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        person = Student.where(district_guid: @district_guid, sti_id: @data["Id"]).first
        if person
          person.update_attributes(person_mapping, as: :admin)
          person.user.update_attributes(user_mapping) if person.recovery_password.nil?
        else
          person = Student.create(person_mapping, as: :admin)
          person.user = Spree::User.new  if person.user.nil?
          person.user.update_attributes(user_mapping) if person.recovery_password.nil?
          person.user.confirmed_at = Time.now
          person.save          
        end  
        if person
          schools = Hash.from_xml(@data["SchoolsXml"])
          if schools == nil
            Rails.logger.error("Bad XML response for guid: #{@district_guid} schools: #{@data.inspect}")
            return
          end        
          if schools
            schools = schools["root"]
            if schools["row"].kind_of?(Array) 
              schools_ids = schools["row"].collect { | x | x["id"] }          
            else
              schools_ids = [schools["row"]["id"]]
            end
            schools_ids.each do |sti_school_id|          
              school = School.where(:district_guid => @district_guid, :sti_id => sti_school_id).first
              person_school_link = ::PersonSchoolLink.where(:person_id => person.id, :school_id => school.id).first_or_initialize
              person_school_link.skip_onboard_credits = true
              person_school_link.status = "active"
              person_school_link.save(:validate => false)
            end
          end
        end  
      end

      private

      def person_mapping
        {
          sti_id: @data["Id"],
          gender: @data["Gender"] == "M" ? "Male" : "Female",
          district_guid: @district_guid,
          first_name: @data["FirstName"],
          last_name: @data["LastName"],
          grade: @data["GradeLevel"],
          status: "active"
        }
      end

      def user_mapping
        username = generate_username_for_district(@district_guid, @data["FirstName"], @data["LastName"])
        password = UUIDTools::UUID.random_create.to_s[0..3]
        {
          username: username,
          password: password,
          password_confirmation: password,
          confirmed_at: Time.now
        }
      end

      def generate_username_for_district(district_guid, first_name, last_name, iteration = 0)
        username = first_name.downcase[0] + last_name.downcase[0..4]
        username += iteration.to_s if iteration > 0
        return username if username_unique_for_district?(district_guid, username)
        return generate_username_for_district(district_guid, first_name, last_name, iteration + 1)
      end

      def username_unique_for_district?(district_guid, username)
        !Student.joins(:user).where(:district_guid => district_guid, :user => {:username => username}).any?
      end
      
    end
  end
end
