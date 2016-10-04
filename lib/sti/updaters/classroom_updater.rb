module STI
  module Updaters
    class ClassroomUpdater
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        classroom = Classroom.where(district_guid: @district_guid, sti_id: @data["Id"]).first
        if classroom
          classroom.update_attributes(mapping)         
          ClassroomActivator.new(classroom.id).execute!
        else
          classroom = Classroom.create(mapping)
        end
        if classroom  
          teacher = Teacher.where(:district_guid => @district_guid, :sti_id => @data["TeacherId"]).first
          if teacher
            #Rails.logger.debug "AKT: Fetch PersonSchoolLink for district_guid #{@district_guid} and school sti_id #{@data["SchoolId"]}"
            school = School.where(district_guid: @district_guid, sti_id: @data["SchoolId"], status: "active").last
            #Rails.logger.debug "AKT: School: #{school}"
            person_school_link = PersonSchoolLink.where(person_id: teacher.id, school_id: school.id, status: "active").first
            if !person_school_link
              person_school_link = PersonSchoolLink.where(person_id: teacher.id, school_id: school.id).first_or_create
              person_school_link.status = "active"
              person_school_link.save
            end
            #Rails.logger.debug "AKT: PSL #{person_school_link.inspect}"
            PersonSchoolClassroomLink.where(:person_school_link_id => person_school_link.id, :classroom_id => classroom.id).first_or_create     
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