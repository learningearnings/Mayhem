module Reports
  class StudentRosterController < Reports::BaseController
    def show
      if params[:classroom] && params[:classroom] != "all"
        classroom = Classroom.find(params[:classroom])
      else
        classroom = nil
      end
      report = Reports::StudentRoster.new params.merge(school: current_school, person: current_person, classroom: classroom)
      report.execute!
      render 'show', locals: {
        report: report,
        classrooms: current_person.classrooms_for_school(current_school),
        grades: current_school.grades
      }
    end
  end
end
