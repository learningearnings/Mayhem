class DelayedReportsController < LoggedInController
  def index
    @reports = current_person.delayed_reports
  end

  def show
    @report = current_person.delayed_reports.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => {state: @report.state, report_data: JSON.parse(@report.report_data) }}
    end
  end
end
