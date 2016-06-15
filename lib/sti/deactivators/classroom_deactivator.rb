module STI
  module Deactivators
    class ClassroomDeactivator
      def initialize(data, district_guid)
        @data = data
        @district_guid = district_guid
      end

      def execute!
        classroom = Classroom.where(:district_guid => @district_guid, :sti_id => @data["Id"]).first
        if classroom
          ::ClassroomDeactivator.new(classroom.id).execute!
        end  
      end
    end
  end
end
