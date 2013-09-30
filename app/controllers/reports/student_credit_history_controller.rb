module Reports
  class StudentCreditHistoryController < Reports::BaseController
    def show
      if params[:classroom] && params[:classroom] != "all"
        classroom = Classroom.find(params[:classroom])
      else
        classroom = nil
      end
      # If no student_filter_type, select 'all_at_school'
      params[:student_filter_type] ||= 'all_at_school'
      report = Reports::StudentCreditHistory.new params.merge(school: current_school, person: current_person, classroom: classroom, student_filter_type: params[:student_filter_type])
      report.execute!
      render 'show', locals: {
        report: report,
        classrooms: current_person.classrooms_for_school(current_school)
      }
    end
  end
end
