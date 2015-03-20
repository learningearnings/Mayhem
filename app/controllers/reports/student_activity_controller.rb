module Reports
  class StudentActivityController < Reports::BaseController
    def show
      report = Reports::StudentActivity.new params.merge(school: current_school)
      report.execute!
      MixPanelWorker.new.track(current_user.id, 'View Activity Report')
      render 'show', locals: { report: report }
    end
  end
end
