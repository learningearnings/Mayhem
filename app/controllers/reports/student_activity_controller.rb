module Reports
  class StudentActivityController < Reports::BaseController
    def show
      report = Reports::StudentActivity.new params.merge(school: current_school)
      report.execute!
      render 'show', locals: { report: report }
    end
  end
end
