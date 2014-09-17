ActiveAdmin.register_page "District Reports" do
  menu :parent => "Reports", :priority => 1

  content do
    render partial: "admin/reports/district"
  end

  page_action :run, :method => :post do
    begin
      school_ids = School.where(discrict_guid: params[:id]).pluck(:id)
      UserActivityReportWorker.perform_async({school_ids: school_ids})
      render json: { :status => 200, :notice => 'User activity report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'User activity report failed to start.' }
    end
  end

  controller do
    def index
      # FIXME: Actually do good things here
      @districts = School.group(:district_guid, :id).select([:district_guid, :name]).collect{|x| [x.name, x.district_guid]}
    end
  end
end
