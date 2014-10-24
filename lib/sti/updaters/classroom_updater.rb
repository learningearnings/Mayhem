module STI
  module Updaters
    class ClassroomUpdater
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        classroom = Classroom.where(district_guid: @district_guid, sti_id: @data["Id"]).first
        classroom.update_attributes(mapping)

        ClassroomActivator.new(classroom.id).execute!

        teacher = Teacher.where(:district_guid => @district_guid, :sti_id => @data["TeacherId"]).first
        person_school_link = teacher.person_school_links.includes(:school).where("schools.district_guid" => @district_guid, "schools.sti_id" => @data["SchoolId"]).first
        PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_create
      end

      private

      def mapping
        {
          school_id: School.where(district_guid: @district_guid, sti_id: @data["SchoolId"]).first.id,
          name: [@data["Name"], @data["Periods"]].join(" "),
          sti_id: @data["Id"],
          district_guid: @district_guid
        }
      end
    end
  end
end
