require_relative './base_importer'

module Importers
  class Le
    class ClassroomDetailsImporter < BaseImporter
      protected
      def run
        classroom_link_data.each do |datum|
          person = existing_person(datum[:legacy_user_id])
          classroom = existing_classroom(datum[:legacy_classroom_id])
          if(person && classroom)
            person << classroom
            person.person_school_links.each{|psl| psl.activate! unless psl.active? }
            person.person_school_classroom_links.each{|pscl| pscl.activate! unless pscl.active? }
          end
        end
      end

      def classroom_link_data
        parsed_doc.map do |classroom_link|
          {
             legacy_classroom_id: classroom_link["classroomID"],
             legacy_user_id: classroom_link["userID"]
          }
        end
      end

      def existing_classroom(uuid)
        Classroom.where(legacy_classroom_id: uuid).first
      end

      def existing_person(uuid)
        Person.where(legacy_user_id: uuid).first
      end
    end
  end
end
