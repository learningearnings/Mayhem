module Powerschool
  class Section < PowerschoolObject
    attr_accessor(:id, :school_id, :course_id, :term_id, :section_number, :expression, :staff_id)


    def term(force_refresh = false)
      get_term(force_refresh)
    end

    def enrollments(force_refresh = false)
      get_enrollments(force_refresh)
    end

    def course(force_refresh = false)
      get_course(force_refresh)
    end

    def staff(force_refresh = false)
      get_staff(force_refresh)
    end

    def gradebook_type
      client.get_section_gradebook_type(id)
    end

    private
    def get_staff(refresh)
      with_local_cache(:staff, refresh) do
        client.get_staff_member(staff_id)
      end
    end

    def get_enrollments(refresh)
      with_local_cache(:enrollments, refresh) do
        client.get_enrollments(id)
      end
    end

    def get_course(refresh)
      with_local_cache(:course, refresh) do
        client.get_course(course_id)
      end
    end

    def get_term(refresh)
      with_local_cache(:course, refresh) do
        client.get_term(term_id)
      end
    end
  end
end