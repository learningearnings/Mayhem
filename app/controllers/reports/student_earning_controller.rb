module Reports
  class StudentEarningController < Reports::BaseController
    def show
      report = Reports::StudentEarning.new params.merge(school: current_school)
      report.execute!
      MixPanelTrackerWorker.perform_async(current_user.id, 'View Student Earning', mixpanel_options)
      render 'show', locals: {
        report: report
      }
    end
  end
end