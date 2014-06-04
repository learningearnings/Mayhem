module Reports
  class StudentRosterController < Reports::BaseController
    def show
      report = Reports::StudentRoster.new params.merge(school: current_school, person: current_person)
      students = report.execute!
      render 'show', locals: {
        students: students,
        classrooms: current_person.classrooms_for_school(current_school),
        grades: current_school.grades
      }
    end
  end
end
