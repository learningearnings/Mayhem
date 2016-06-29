module Reports
	class StudentEarningController < Reports::BaseController
		def show
			if params[:classroom_filter].present?
        @classroom_filter = Classroom.find(params[:classroom_filter]) 
      end
			report = Reports::StudentEarning.new params.merge(school: current_school, logged_in_person: current_person)
			report.execute!
			MixPanelTrackerWorker.perform_async(current_user.id, 'View Student Earning', mixpanel_options)
			render 'show', locals: {
				report: report,
        classrooms: current_person.classrooms_for_school(current_school)
			}
		end
		def credit_transactions
			@student = Student.find(params[:student_id])
			@start_date = DateTime.parse(params[:start_date])
			@end_date = DateTime.parse(params[:end_date])
			@credit_type = params[:credit_type] 
			@otu_codes = OtuCode.total_credited(@student.id, @start_date, @end_date).reverse_order.page(params[:page]).per(5)
			if @credit_type == "deposited"
				@otu_codes = @otu_codes.inactive
			elsif @credit_type == "undeposited"
				@otu_codes = @otu_codes.active
			end 
			respond_to do |format|
				format.html { render partial: 'credit_transactions', layout: false,  locals: { otu_codes: @otu_codes, credit_type: @credit_type, student: @student, start_date: @start_date, end_date: @end_date } }
				format.js 
			end
		end
		def print_credit_transactions
			if params[:student_id].present? && params[:student_id].kind_of?(Array)
			  student_ids = params[:student_id].map { |i| i.to_i }
			elsif params[:student_id].kind_of?(String)
				student_ids = params[:student_id].split(",").map { |i| i.to_i }
      else
        flash[:error] = "Please select students from the list."
        redirect_to :back and return
      end	
			@students = Student.selected_students(student_ids)
			@start_date = DateTime.parse(params[:start_date])
			@end_date = DateTime.parse(params[:end_date])
			@credit_type = params[:credit_type] ? params[:credit_type] : "total_credit"
			respond_to do |format|
				format.html { render 'print_credit_transactions',  locals: { otu_codes: @otu_codes, credit_type: @credit_type, student: @student, start_date: @start_date, end_date: @end_date } }
				format.js 
			end
		end

	end
end