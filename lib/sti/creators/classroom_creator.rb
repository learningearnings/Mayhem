module STI
  module Creators
    class ClassroomCreator
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        
        Rails.logger.debug "AKT: #{@data.inspect}"
        classroom = Classroom.create(mapping)

        classroom.reload

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
