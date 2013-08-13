require_relative './base_importer'

module Importers
  class Le
    class ClassroomDetailsImporter < BaseImporter
      def call
        classroom_link_data.each do |datum|
          existing_person(datum[:legacy_user_id]) << existing_classroom(datum[:legacy_classroom_id])
        end
      end

      protected
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
