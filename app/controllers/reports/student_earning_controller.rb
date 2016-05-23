module Reports
  class StudentEarningController < Reports::BaseController
    def show
      report = Reports::StudentEarning.new params.merge(school: current_school)
      report.execute!
      MixPanelTrackerWorker.perform_async(current_user.id, 'View Student Earning', mixpanel_options)
      render 'show', locals: {
        report: report
      }
    end
    def credit_transactions
      student = Student.find(params[:student_id])
      start_date = DateTime.parse(params[:start_date])
      end_date = DateTime.parse(params[:end_date])
      @recent_checking_amounts = OtuCode.where("student_id = ? AND created_at >= ? AND created_at <= ?",student.id, start_date, end_date).reverse_order.page(params[:page]).per(5)
      
      respond_to do |format|
        format.html { render partial: 'credit_transactions', layout: false,  locals: { amounts: @recent_checking_amounts } }
        format.js
      end
    end
  end
end