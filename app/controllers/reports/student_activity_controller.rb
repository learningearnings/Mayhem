module Reports
  class StudentActivityController < Reports::BaseController
    def show	
    	if params[:classroom_filter].present?
        @classroom_filter = Classroom.find(params[:classroom_filter]) 
      end
      report = Reports::StudentActivity.new params.merge(school: current_school, logged_in_person: current_person)
      report.execute!
      MixPanelTrackerWorker.perform_async(current_user.id, 'View Activity Report', mixpanel_options)
      render 'show', locals: {
        report: report,
        classrooms: current_person.classrooms_for_school(current_school) }
    end
  end
end
