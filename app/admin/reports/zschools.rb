ActiveAdmin.register_page "School Reports" do
  menu :parent => "Reports", :priority => 2

  content do
    render partial: "admin/reports/school"
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
      options.merge!(school_ids: params[:id])
      options.merge!(to_email: current_user.email)      
      UserActivityReportWorker.perform_async(options)
      render json: { :status => 200, :notice => "User activity report has been started." }
    rescue Exception => e
      render json: { :status => 422, :notice => 'User activity report failed to start.' }
    end
  end

  controller do
    def index
      @schools = School.status_active.order(:name).select([:id, :name]).collect{|x| [x.name, x.id]}.unshift(["All Schools", nil])
    end
  end
end
