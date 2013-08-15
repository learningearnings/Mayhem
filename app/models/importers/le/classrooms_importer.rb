require_relative './base_importer'

module Importers
  class Le
    class ClassroomsImporter < BaseImporter
      protected
      def run
        classroom_data.each do |datum|
          find_or_create_classroom(datum)
        end
      end

      def classroom_data
        parsed_doc.map do |classroom|
          school = existing_school(classroom["schoolID"])
          if school
            {
              classroom: {
                name: classroom["classroomtitle"],
                legacy_classroom_id: classroom["classroomID"],
                school_id: school.id
              },
              legacy_user_id: classroom["userID"]
            }
          end
        end.compact
      end

      def existing_school(uuid)
        School.where(legacy_school_id: uuid).first
      end

      def find_or_create_classroom(datum)
        existing_classroom(datum[:classroom]) || create_classroom(datum)
      end

      def create_classroom(datum)
        Classroom.create(datum[:classroom]).tap do |classroom|
          teacher = existing_teacher(datum[:legacy_user_id])
          if teacher
            teacher << classroom
            classroom.assign_owner(teacher)
            teacher.activate! unless teacher.active?
            teacher.person_school_links.each{|psl| psl.activate! unless psl.active? }
            teacher.person_school_classroom_links.each{|pscl| pscl.activate! unless pscl.active? }
          else
            warn "Couldn't find teacher with legacy user id #{datum[:legacy_user_id]} when importing classroom #{datum[:classroom][:legacy_classroom_id]}"
          end
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
