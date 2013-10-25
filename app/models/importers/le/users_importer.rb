require_relative './base_importer'

module Importers
  class Le
    class UsersImporter < BaseImporter
      protected
      def run
        person_data.each do |datum|
          find_or_create_person(datum)
        end
      end

      def person_data
        parsed_doc.map do |person|
          {
            person: {
              first_name: person["userfname"],
              last_name: person["userlname"],
              grade: person["grade"],
              legacy_user_id: person["UserID"],
              type: type_for(person["usertypeID"])
            },
            school_uuid: person["SchoolID"],
            user: {
              username: person["username"],
              password: person["recoverypassword"],
              email: person["useremail"]
            }
          }
        end
      end

      def existing_school(uuid)
        School.where(legacy_school_id: uuid).first
      end

      def find_or_create_person(datum)
        if existing_person(datum[:person])
          update_person(datum)
        else
          create_person(datum)
        end
      end

      def create_person(datum)
        begin
          person_class_for(datum).create(datum[:person], as: :admin).tap do |person|
            person << existing_school(datum[:school_uuid])
            user = person.user
            user.username = datum[:user][:username]
            user.password = datum[:user][:password]
            user.email = datum[:user][:email]
            user.save(validate: false)
            person.activate!
          end
        rescue Exception => e
          warn "Got exception for #{datum.inspect} - #{e.inspect}"
        end
      end

      def update_person(datum)
        person = existing_person(datum)
        person.update_attributes(datum[:person])
        person.user.update_attributes(datum[:user])
      end

      def existing_person(datum)
        Person.where(legacy_user_id: datum[:legacy_user_id]).first
      end

      def type_for(person_type)
        {
          "1" => "Student",
          "2" => "Teacher",
          "3" => "SchoolAdmin",
          "5" => "SchoolAdmin"
        }[person_type] || "Student"
      end

      def person_class_for(datum)
        type = datum[:person][:type]
        Kernel.const_get(type)
      end
    end
  end
end
