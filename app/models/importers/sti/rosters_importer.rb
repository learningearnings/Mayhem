require_relative './base_importer'
module Importers
  class Sti
    class RostersImporter < BaseImporter
      def call
        classroom_data.each do |datum|
          classroom = find_or_create_classroom(datum)
          assign_student(classroom, datum[:student_uuid])
        end
      end

      protected
      def classroom_data
        parsed_doc.xpath("//Rosters/Roster").map do |roster|
          {
            classroom: {
              name: roster["Name"],
              sti_uuid: roster["FullSectionNumber"],
              school_id: school_by_guid(roster["SchoolGuid"]).id
            },
            teacher_uuid: roster["StaffGuid"],
            student_uuid: roster["StudentGuid"]
          }
        end
      end

      def school_by_guid(guid)
        School.where(sti_uuid: guid).first
      end

      def teacher_by_uuid(guid)
        Teacher.where(sti_uuid: guid).first
      end

      def assign_owner(classroom, guid)
        classroom.assign_owner(teacher_by_uuid(guid))
      end

      def find_or_create_classroom(datum)
        existing_classroom(datum[:classroom]) || create_classroom(datum)
      end

      def existing_classroom(classroom_datum)
        Classroom.where(sti_uuid: classroom_datum[:sti_uuid]).first
      end

      def create_classroom(datum)
        Classroom.create(datum[:classroom]).tap do |classroom|
          classroom.assign_owner(teacher_by_uuid(datum[:teacher_uuid]))
        end
      end

      def assign_student(classroom, student_uuid)
        student_by_uuid(student_uuid) << classroom
      end

      def student_by_uuid(uuid)
        Student.where(sti_uuid: uuid).first
      end
    end
  end
end
