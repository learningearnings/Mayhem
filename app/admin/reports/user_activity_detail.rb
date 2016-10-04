ActiveAdmin.register_page "User Activity Detail Report" do
  menu :parent => "Reports", :priority => 3

  content do
    render partial: "admin/reports/user_activity_detail_reports"
  end

  page_action :run, :method => :post do
    begin
      options = {}
      if params[:start_date]
        start_date = Time.strptime(params[:start_date], "%m/%d/%Y")
        options.merge!(beginning_day: start_date)
      end
      if params[:end_date]
        end_date = Time.strptime(params[:end_date], "%m/%d/%Y")
        options.merge!(ending_day: end_date)
      end      
      if params[:districts]
        options.merge!(districts: params[:districts])
      end 
      if params[:email_recipients]
        options.merge!(email_recipients: params[:email_recipients])
      end           
      UserActivityDetailReportWorker.perform_async(options)
      render json: { :status => 200, :notice => 'User Activity Detail report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'User Activity Detail failed to start.' }
    end
  end
end
