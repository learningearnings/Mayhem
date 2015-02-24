module STI
  module Creators
    class RosterCreator
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        student = Student.where(district_guid: @district_guid, sti_id: @data["StudentId"]).first
        classroom = Classroom.where(district_guid: @district_guid, sti_id: @data["SectionId"]).first
        if student && classroom
          psl = student.person_school_links.where(school_id: student.school.id).first
          pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: classroom.id).first_or_create
          pscl.activate
        end
      end
    end
  end
end
