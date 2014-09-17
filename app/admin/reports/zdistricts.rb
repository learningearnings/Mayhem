ActiveAdmin.register_page "District Reports" do
  menu :parent => "Reports", :priority => 1

  content do
    render partial: "admin/reports/district"
  end

  page_action :run, :method => :post do
    begin
      UserActivityReportWorker.perform_async
      render json: { :status => 200, :notice => 'User activity report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'User activity report failed to start.' }
    end
  end

  controller do
    def index
      @districts = [
        ["District 1", "1"],
        ["District 2", "2"],
        ["District 3", "3"]
      ]
    end
  end
end
