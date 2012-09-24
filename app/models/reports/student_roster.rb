# NOTE: this is an array-based report, as opposed to an ActiveRelation-based
# report like the Purchases Report.  This is less elegant, but should be
# sufficiently fast to not matter afaik.  Metrics will tell. -ja
module Reports
  class StudentRoster < Reports::Base
    def initialize params
      super
      @person         = params[:person]
      @school         = params[:school]
      @classroom      = params[:classroom]
      @grade_filter   = params[:grade_filter]
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
          base_hash[classroom] = send(filter, students) || []
        end
      end
      base_hash
    end

    def sort_by_filter(base)
      case @sort_by_filter
      when "First, Last"
        base.sort_by {|student| "#{student.first_name}, #{student.last_name}"}
      when "Last, First"
        base.sort_by {|student| "#{student.last_name}, #{student.first_name}"}
      when "Username"
        base.sort_by {|student| student.user.username }
      when "Grade"
        base.sort_by {|student| student.grade }
      else
        base
      end
    end

    def student_classroom_base_hash
      # First, get teacher's classrooms for this school
      if @classroom
        classrooms = [@classroom]
      else
        classrooms = @person.classrooms_for_school(@school)
      end

      # NOTE: I'm doing this in memory rather than sql, because my sql-fu is
      # weak and this won't be big
      hash = {}
      classrooms.each do |classroom|
        students = classroom.students
        if @grade_filter && @grade_filter != 'all'
          students = students.for_grade(@grade_filter)
        end
        hash[classroom] = students
      end
      hash
    end

    def generate_row(classroom, student)
      Reports::Row[
        classroom: classroom,
        grade:     student.grade,
        student:   student,
        username:  student.user.username
      ]
    end

    def headers
      {
        classroom: "Classroom",
        grade:     "Grade",
        student:   "Student",
        username:  "Username"
      }
    end
  end
end
