module Reports
  class PurchasesController < Reports::BaseController

    def show
      params[:page] ||= 1
      report = Reports::Purchases.new params.merge(school: current_school, :page => params[:page])
      report.execute!
      render 'show', locals: { report: report }
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
