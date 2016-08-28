module Reports
  class TeacherActivityController < Reports::BaseController
    def show
      report = Reports::TeacherActivity.new params.merge(school: current_school, logged_in_person: current_person)
      report.execute!
      render 'show', locals: { report: report }
    end
  end
end
