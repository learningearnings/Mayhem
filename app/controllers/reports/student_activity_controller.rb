module Reports
  class StudentActivityController < Reports::BaseController
    def show
      report = Reports::StudentActivity.new params.merge(school: current_school)
      report.execute!
      MixPanelTrackerWorker.perform_async(current_user.id, 'View Activity Report', mixpanel_options)
      render 'show', locals: { report: report }
    end
  end
end
