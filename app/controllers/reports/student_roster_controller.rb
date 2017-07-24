module Reports
  class StudentRosterController < Reports::BaseController
    def show
      if params[:classroom] and params[:classroom] != "all"
        @classroom = Classroom.find(params[:classroom]) 
      end      
      report = Reports::StudentRoster.new params.merge(school: current_school, person: current_person)
      students = report.execute!
      #MixPanelTrackerWorker.perform_async(current_user.id, 'View Student Roster', mixpanel_options)
      render 'show', locals: {
        students: students,
        classrooms: current_person.classrooms_for_school(current_school),
        grades: current_school.grades
      }
    end
  end
end
