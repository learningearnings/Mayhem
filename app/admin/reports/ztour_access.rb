ActiveAdmin.register_page "Tour Access Report" do
  menu :parent => "Reports", :priority => 3

  content do
    render partial: "admin/reports/tour_access_reports"
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
      TourAccessReportWorker.perform_async(options)
      render json: { :status => 200, :notice => 'Tour Access report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'Tour Access report failed to start.' }
    end
  end
end
