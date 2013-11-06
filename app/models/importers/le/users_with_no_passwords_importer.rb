require_relative './base_importer'

module Importers
  class Le
    class UsersWithNoPasswordsImporter < BaseImporter
      protected
      def run
        users_with_no_passwords.each do |datum|
          STDOUT.puts datum.inspect
          #update_person(datum)
        end
      end

      def users_with_no_passwords
        person_data.select do |person|
          person[:user][:password] == "\\N"
        end
      end

      def person_data
        parsed_doc.map do |person|
          {
            person: {
              first_name: person["userfname"],
              last_name: person["userlname"],
              grade: person["grade"],
              legacy_user_id: person["UserID"]
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

      def update_person(datum)
        person = existing_person(datum)
        user = person.user
        user.password = person.user.password_confirmation = datum[:user][:password]
        user.save
      end

      def existing_person(datum)
        Person.where(legacy_user_id: datum[:legacy_user_id]).first
      end
    end
  end
end
