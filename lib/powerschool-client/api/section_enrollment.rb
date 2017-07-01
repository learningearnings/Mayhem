module Powerschool
  class SectionEnrollment < PowerschoolObject
    attr_accessor(:id, :section_id, :student_id, :entry_date, :exit_date, :dropped)

    def student(refresh=false)
      get_student(refresh)
    end

    private

    def get_student(refresh)
      with_local_cache(:student, refresh) do
        @client.get_student(student_id)
      end
    end
  end
end