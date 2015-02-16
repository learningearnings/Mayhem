module Reports
  class StudentRoster
    def initialize params
      @person         = params[:person]
      @school         = params[:school]
      @classroom      = params[:classroom]
      @grade_filter   = params[:grade_filter]
      @sort_by_filter = params[:sort_by]
    end

    def execute!
      bucket = @school.students
      bucket = bucket.for_grade(@grade_filter) if @grade_filter && @grade_filter != "all"
      if @classroom && @classroom != "all"
        bucket = bucket.joins(:person_school_classroom_links).where(:person_school_classroom_links => {:classroom_id => @classroom, :status => :active})
      end
      bucket
    end
  end
end
