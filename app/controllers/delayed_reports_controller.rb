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
  
  def status delayed_report_id
    delayed_report_status = current_person.delayed_reports.find(params[:id]).state
    respond_to do |format|
      format.json { render :json => delayed_report_status }
    end
  end

end
