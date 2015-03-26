ActiveAdmin.register_page "Sign Ups  Report" do
  menu :parent => "Reports", :priority => 3

  content do
    render partial: "admin/reports/sign_ups_reports"
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
      SignUpsReportWorker.perform_async(options, current_user)
      render json: { :status => 200, :notice => 'Sign ups report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'Sign ups report failed to start.' }
    end
  end
end
