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
      @credit_type = params[:credit_type] 
      @otu_codes = OtuCode.total_credited(student.id, start_date, end_date).reverse_order.page(params[:page]).per(5)
      if @credit_type == "deposited"
        @otu_codes = @otu_codes.inactive
      elsif @credit_type == "undeposited"
        @otu_codes = @otu_codes.active
      end 
      respond_to do |format|
        format.html { render partial: 'credit_transactions', layout: false,  locals: { otu_codes: @otu_codes, credit_type: @credit_type, student_name: student.name } }
        format.js 
      end
    end
  end
end