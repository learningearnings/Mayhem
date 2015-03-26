ActiveAdmin.register_page "District Reports" do
  menu :parent => "Reports", :priority => 1

  content do
    render partial: "admin/reports/district"
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
      if params[:id] == "all"
        school_ids = School.where(district_guid: District.pluck(:guid)).pluck(:id)
        options.merge!(school_ids: school_ids)
      elsif params[:id] == "alsde"
        school_ids = School.where(district_guid: District.where(alsde_study: true).pluck(:guid)).pluck(:id)
        options.merge!(school_ids: school_ids)
      else
        school_ids = School.where(district_guid: params[:id]).pluck(:id)
        options.merge!(school_ids: school_ids)
      end
      options.merge!(to_email: current_user.email)
      UserActivityReportWorker.perform_async(options)
      render json: { :status => 200, :notice => 'User activity report has been started.' }
    rescue Exception => e
      render json: { :status => 422, :notice => 'User activity report failed to start.' }
    end
  end

  controller do
    def index
      @districts = District.order(:name).all.collect{|x| [x.name, x.guid]}.unshift(["All ALSDE", "alsde"]).unshift(["All Districts", "all"])
    end
  end
end
