module Reports
  class PurchasesController < Reports::BaseController

    def new
      report = Reports::Purchases.new params.merge(school: current_school)
      delayed_report = DelayedReport.create(person_id: current_person.id)
      DelayedReportWorker.perform_async(Marshal.dump(report), delayed_report.id)
      redirect_to purchases_report_show_path(delayed_report.id, params)
    end

    def show
      delayed_report = DelayedReport.find(params[:id])
      respond_to do |format|
        format.html { render 'show', locals: { report: delayed_report } }
        format.json { render :json => delayed_report }
      end
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
