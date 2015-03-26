ActiveAdmin.register_page "ALSDE Report" do
  menu :parent => "Reports", :priority => 3

  content do
    render partial: "admin/reports/alsde_reports"
  end

  page_action :run, :method => :post do
    begin
      options = {}
      if params[:start_date]
        start_date = Time.strptime(params[:start_date], "%m/%d/%Y")
        options.merge!(start_date: start_date)
      end
      if params[:end_date]
        end_date = Time.strptime(params[:end_date], "%m/%d/%Y")
        options.merge!(end_date: end_date)
      end
      ALSDEStudyReportWorker.perform_async(options, current_user)
      render json: { :status => 200, :notice => 'ALSDE study report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'ALSDE study report failed to start.' }
    end
  end
end
