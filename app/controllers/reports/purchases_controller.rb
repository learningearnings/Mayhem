module Reports
  class PurchasesController < Reports::BaseController

    def new
      report = Reports::Purchases.new params.merge(school: current_school)
      delayed_report = DelayedReport.create(person_id: current_person.id)
      DelayedReportWorker.perform_async(Marshal.dump(report), delayed_report.id)
      redirect_to purchases_report_show_path(delayed_report.id, params)
    end

    def show
      delayed_report = current_person.delayed_reports.find(params[:id])
      respond_to do |format|
        format.html { render 'show', locals: { report: delayed_report } }
        format.json { render :json => delayed_report }
      end
    end

    def export
      delayed_report = current_person.delayed_reports.find(params[:id])
      @report = ReportExporter.new(delayed_report).export
      send_data @report, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=purchase_report_#{params[:id]}.csv"
    end

    def refund_purchase
      reward_delivery = RewardDelivery.find(params[:reward_delivery_id])
      if reward_delivery.refund_purchase
        flash[:notice] = "Successfully refunded purchase"
      else
        flash[:alert] = "Could not refund the purchase you selected"
      end
      redirect_to purchases_report_path
    end

  end
end
