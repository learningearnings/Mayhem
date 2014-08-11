module Reports
  class StudentCreditHistoryController < Reports::BaseController
    def new
      binding.pry
      if params[:classroom] && params[:classroom] != "all"
        classroom = Classroom.find(params[:classroom])
      else
        classroom = nil
      end
      # If no student_filter_type, select 'all_at_school'
      params[:student_filter_type] ||= 'all_at_school'
      report = Reports::StudentCreditHistory.new params.merge(school: current_school, person: current_person, classroom: classroom, student_filter_type: params[:student_filter_type])
      delayed_report = DelayedReport.create(person_id: current_person.id)
      DelayedReportWorker.perform_async(Marshal.dump(report), delayed_report.id)
      redirect_to student_credit_history_report_show_path(delayed_report.id, params)
    end

    def show
      delayed_report = current_person.delayed_reports.find(params[:id])
      respond_to do |format|
        format.html {
          render 'show', locals: {
            report: delayed_report,
            classrooms: current_person.classrooms_for_school(current_school)
          }
        }
        format.json { render :json => delayed_report }
      end
    end
  end
end
