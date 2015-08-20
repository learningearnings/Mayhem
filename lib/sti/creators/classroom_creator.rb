module STI
  module Creators
    class ClassroomCreator
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        classroom = Classroom.create(mapping)

        classroom.reload

        teacher = Teacher.where(:district_guid => @district_guid, :sti_id => @data["TeacherId"]).first
        if teacher
          person_school_link = teacher.person_school_links.includes(:school).where("schools.district_guid" => @district_guid, "schools.sti_id" => @data["SchoolId"]).first
          if classroom and person_school_link
            PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_create
          else
            Rails.logger.error("ClassroomCreator: Could not create classroom link: teacher: #{teacher.inspect}, classroom: #{classroom.inspect}")
            puts "ClassroomCreator: Could not create classroom link: teacher: #{teacher.inspect}, classroom: #{classroom.inspect}"  
          end
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
