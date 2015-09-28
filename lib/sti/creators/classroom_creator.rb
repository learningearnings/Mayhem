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
        classroom.save
        classroom.reload
        Rails.logger.debug "AKT: #{classroom.inspect}"
        teacher = Teacher.where(:district_guid => @district_guid, :sti_id => @data["TeacherId"]).first
        if teacher
          Rails.logger.debug "AKT: Fetch PersonSchoolLink for district_guid #{@district_guid} and school sti_id #{@data["SchoolId"]}"
          person_school_link = teacher.person_school_links.includes(:school).where("schools.district_guid" => @district_guid, "schools.sti_id" => @data["SchoolId"]).first
          Rails.logger.debug "AKT: #{person_school_link.inspect}"
          PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_create
        end
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
