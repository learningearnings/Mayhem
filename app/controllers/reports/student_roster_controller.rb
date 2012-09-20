module Reports
  class StudentRosterController < Reports::BaseController
    def show
      report = Reports::StudentRoster.new params.merge(school: current_school, person: current_person)
      report.execute!
      render 'show', locals: { report: report }
    end
  end
end
