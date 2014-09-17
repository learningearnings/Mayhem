ActiveAdmin.register_page "School Reports" do
  menu :parent => "Reports", :priority => 2

  content do
    render partial: "admin/reports/school"
  end

  page_action :run, :method => :post do
    begin
      UserActivityReportWorker.perform_async({school_ids: params[:id]})
      render json: { :status => 200, :notice => 'User activity report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'User activity report failed to start.' }
    end
  end

  controller do
    def index
      @schools = School.select([:id, :name]).collect{|x| [x.name, x.id]}
    end
  end
end
