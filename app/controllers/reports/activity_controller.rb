module Reports
  class ActivityController < Reports::BaseController
    def show
      report = Reports::Activity.new params.merge(school: current_school)
      report.execute!
      render 'show', locals: {
        report: report
      }
    end
  end
end
