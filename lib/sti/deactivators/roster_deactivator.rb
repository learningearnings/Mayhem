module STI
  module Deactivators
    class RosterDeactivator
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        student = Student.where(district_guid: @district_guid, sti_id: @data["StudentId"]).first
        classroom = Classroom.where(district_guid: @district_guid, sti_id: @data["SectionId"]).first
        if student && classroom
          PersonSchoolClassroomLink.where(classroom_id: classroom.id, person_school_link_id: student.person_school_link_ids).update_all(status: "inactive")
        end
      end
    end
  end
end
