class DelayedReportsController < LoggedInController
  def index
    @reports = current_person.delayed_reports
  end

  def show
    @report = current_person.delayed_reports.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => {state: "completed", report_data: [{:some_key => :some_value, :some_other_key => :value_1}, {:some_key => :some_other_value, :some_other_key => :value_2}]}}
    end
  end
end
