ActiveAdmin.register_page "Reports" do
  content do
    render "index"
  end

  page_action :run_student_activity_report, :method => :get do
    begin
      UserActivityReportWorker.perform_async
      flash[:notice] = 'User activity report has been started.'
    rescue Exception => e
      flash[:notice] = 'User activity report failed to start.'
    ensure
      redirect_to '/admin/reports'
    end
  end
end
