module Reports
  class StudentCreditHistoryController < Reports::BaseController
    def new
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
      #MixPanelTrackerWorker.perform_async(current_user.id, 'View Student Credit History Report', mixpanel_options)
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

    def checking_transactions
      student = Student.find(params[:student_id])
      @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: student.checking_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(params[:page]).per(5))
      respond_to do |format|
        format.html { render partial: 'banks/checking_ledger_table', layout: false,  locals: { amounts: @recent_checking_amounts } }
        format.js
      end
    end

    def savings_transactions
      student = Student.find(params[:student_id])
      @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: student.savings_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(params[:page]).per(5))
      respond_to do |format|
        format.html { render partial: 'banks/savings_ledger_table', layout: false, locals: { amounts: @recent_savings_amounts } }
        format.js
      end
    end
  end
end
