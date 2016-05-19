module Reports
  class PurchasesController < Reports::BaseController

    def new
      if params[:reports_purchases_params].blank?
        report = Reports::Purchases.new params.merge(school: current_school, status: "pending", teacher: current_person)
      else
        if current_person.is_a?(SchoolAdmin)
          report = Reports::Purchases.new params.merge(school: current_school, status: "pending")
        else
          report = Reports::Purchases.new params.merge(school: current_school, status: "pending", teacher: current_person)
        end         
      end
      delayed_report = DelayedReport.create(person_id: current_person.id)
      DelayedReportWorker.perform_async(Marshal.dump(report), delayed_report.id)
      redirect_to purchases_report_show_path(delayed_report.id, params)
    end

    def show
      delayed_report = current_person.delayed_reports.find(params[:id])
      MixPanelTrackerWorker.perform_async(current_user.id, 'Run Purchase Report', mixpanel_options)
      respond_to do |format|
        format.html { render 'show', locals: { report: delayed_report } }
        format.json { render :json => delayed_report }
      end
    end

    def refund_purchase
      reward_delivery = RewardDelivery.find(params[:reward_delivery_id])
      if reward_delivery.refund_purchase
        respond_to do |format|
          format.html {
            flash[:notice] = "Successfully refunded purchase"
            redirect_to purchases_report_path
          }
          format.json {
            render json: { status: 200, notice: 'Successfully refunded purchase'}
          }
        end
      else
        respond_to do |format|
          format.html {
            flash[:alert] = "Could not refund the purchase you selected"
            redirect_to purchases_report_path
          }
          format.json {
            render json: { status: 422, notice: "Could not refund the purchase you selected"}
          }
        end
      end
    end

  end
end
