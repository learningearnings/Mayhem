module Reports
  class StudentRoster < Reports::Base
    def initialize params
      super
      @person = params[:person]
      @school = params[:school]
      @sort_by_filter = params[:sort_by]
    end

    def execute!
      # get recent line items from the school
      students_with_classrooms.each_pair do |classroom, students|
        students.each do |student|
          @data << generate_row(classroom, student)
        end
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:sort_by_filter]
    end

    def students_with_classrooms
      base_hash = student_classroom_base_hash
      potential_filters.each do |filter|
        student_classroom_base_hash.each_pair do |classroom, students|
          base_hash[classroom] = send(filter, students)
        end
      end
      base_hash
    end

    def sort_by_filter(base)
      case @sort_by_filter
      when "Default"
        base
      when "First, Last"
        base.sort_by {|person| "#{person.first_name}, #{person.last_name}"}
      when "Last, First"
        base.sort_by {|person| "#{person.last_name}, #{person.first_name}"}
      end
    end

    def student_classroom_base_hash
      # First, get teacher's classrooms
      classrooms = @person.classrooms

      # NOTE: I'm doing this in memory rather than sql, because my sql-fu is
      # weak and this won't be big
      hash = {}
      classrooms.each do |classroom|
        students = classroom.students
        if students.any?
          hash[classroom] = students
        else
          hash[classroom] = []
        end
      end
      hash
    end

    def generate_row(classroom, student)
      Reports::Row[
        classroom: classroom,
        student: student
      ]
    end

    def headers
      {
        classroom: "Classroom",
        student: "Student"
      }
    end
  end
end
