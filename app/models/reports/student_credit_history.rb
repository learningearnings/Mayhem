# NOTE: this is an array-based report, as opposed to an ActiveRelation-based
# report like the Purchases Report.  This is less elegant, but should be
# sufficiently fast to not matter afaik.  Metrics will tell. -ja
module Reports
  class StudentCreditHistory < Reports::Base
    def initialize params
      super
      @person         = params[:person]
      @school         = params[:school]
      @classroom      = params[:classroom]
      @sort_by_filter = params[:sort_by]
      @student_filter_type = params[:student_filter_type]
    end

    def execute!
      # get recent line items from the school
      students.each do |student|
        @data << generate_row(student)
      end
    end

    # Will include date_filter, reward_status_filter(delivered, undelivered) and teachers_filter
    # Only Date Filter for now.
    def potential_filters
      [:sort_by_filter]
    end

    def students
      base = students_bucket
      potential_filters.each do |filter|
        base = send(filter, base) || []
      end
      base
    end

    def sort_by_filter(base)
      case @sort_by_filter
      when "First, Last"
        base.sort_by {|student| "#{student.first_name}, #{student.last_name}"}
      when "Last, First"
        base.sort_by {|student| "#{student.last_name}, #{student.first_name}"}
      when "Username"
        base.sort_by {|student| student.user.username }
      else
        base
      end
    end

    def students_bucket
      case @student_filter_type
      when 'all_at_school'
        bucket = @school.students
      when 'students_ive_given_bucks_to'
        bucket = @person.students_ive_given_ebucks_to
      when 'all_my_classrooms'
        bucket = []
        @person.classrooms_for_school(@school).each do |classroom|
          bucket += classroom.students
        end
        bucket.uniq!
      when 'classroom'
        # First, get teacher's classrooms for this school
        if @classroom
          bucket = @classroom.students
        else
          bucket = @school.students
        end
      end

      # NOTE: I'm doing this in memory rather than sql, because my sql-fu is
      # weak and this won't be big
      bucket
    end

    def generate_row(student)
      {
        id:        student.id,
        grade:     student.grade,
        student:   student.name,
        username:  student.user.username,
        checking_balance: student.checking_balance,
        savings_balance: student.savings_balance
      }
    end

    def headers
      {
        student:   "Student",
        username:  "Username",
        checking_balance: "Checking Balance",
        savings_balance: "Savings Balance"
      }
    end
  end
end
