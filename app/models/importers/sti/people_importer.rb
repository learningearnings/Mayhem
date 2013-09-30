require_relative './base_importer'
module Importers
  class Sti
    class PeopleImporter < BaseImporter
      def call
        people_data.each do |datum|
          find_or_create_person(datum)
        end
      end

      protected
      def people_data
        parsed_doc.xpath("//Persons/Person").map do |person|
          {
            person: {
              first_name: person["FirstName"],
              last_name: person["LastName"],
              grade: grade_for(person["GradeLevelName"]),
              gender: person["Gender"],
              sti_uuid: person["Guid"],
              type: type_for(person["PersonType"])
            },
            school_uuid: person["SchoolGuid"]
          }
        end
      end

      def existing_school(uuid)
        School.where(sti_uuid: uuid).first
      end

      def find_or_create_person(datum)
        existing_person(datum[:person]) || create_person(datum)
      end

      def create_person(datum)
        Person.create(datum[:person]).tap do |person|
          person << existing_school(datum[:school_uuid])
        end
      end

      def existing_person(datum)
        Person.where(sti_uuid: datum[:sti_uuid]).first
      end

      def grade_for(grade_level_name)
        grade_level_name.to_i
      end

      def type_for(person_type)
        {
          "S" => "Student",
          "T" => "Teacher"
        }[person_type]
      end
    end
  end
end
