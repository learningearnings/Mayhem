ActiveAdmin.register_page "School Reports" do
  menu :parent => "Reports", :priority => 2

  content do
    render partial: "admin/reports/school"
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
      @schools = [
        ["School 1", "1"],
        ["School 2", "2"],
        ["School 3", "3"]
      ]
    end
  end
end
