module Reports
  class StudentCreditHistoryController < Reports::BaseController
    def show
      if params[:classroom] && params[:classroom] != "all"
        classroom = Classroom.find(params[:classroom])
      else
        classroom = nil
      end
      report = Reports::StudentCreditHistory.new params.merge(school: current_school, person: current_person, classroom: classroom)
      report.execute!
      render 'show', locals: {
        report: report,
        classrooms: current_person.classrooms_for_school(current_school)
      }
    end
  end
end
