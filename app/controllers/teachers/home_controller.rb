module Teachers
  class HomeController < LoggedInController
    def show
      @teacher_dashboard_report = Reports::TeacherDashboardReport.new(:teacher => current_person)
      @teacher_dashboard_report.generate
    end
  end
end
