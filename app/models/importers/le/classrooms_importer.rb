require_relative './base_importer'

module Importers
  class Le
    class ClassroomsImporter < BaseImporter
      def call
        classroom_data.each do |datum|
          find_or_create_classroom(datum)
        end
      end

      protected
      def classroom_data
        parsed_doc.map do |classroom|
          {
            classroom: {
              name: classroom["classroomtitle"],
              legacy_classroom_id: classroom["classroomID"],
              school_id: existing_school(classroom["schoolID"]).id
            },
            legacy_user_id: classroom["userID"]
          }
        end
      end

      def existing_school(uuid)
        School.where(legacy_school_id: uuid).first
      end

      def find_or_create_classroom(datum)
        existing_classroom(datum[:classroom]) || create_classroom(datum)
      end

      def create_classroom(datum)
        Classroom.create(datum[:classroom]).tap do |classroom|
          classroom.assign_owner(existing_teacher(datum[:legacy_user_id]))
        end
      end

      def existing_classroom(datum)
        Classroom.where(legacy_classroom_id: datum[:legacy_classroom_id]).first
      end

      def existing_teacher(uuid)
        Person.where(legacy_user_id: uuid).first
      end
    end
  end
end
