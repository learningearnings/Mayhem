module STI
  module Deactivators
    class ClassroomDeactivator
      def initialize(sti_id, district_guid)
        @sti_id = sti_id
        @district_guid = district_guid
      end

      def execute!
        classroom = Classroom.where(:district_guid => @district_guid, :sti_id => sti_id).first
        ::ClassroomDeactivator.new(classroom.id).execute!
      end
    end
  end
end
