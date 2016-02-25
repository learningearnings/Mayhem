class DeliverRewardsCommandsController < LoggedInController
  # FIXME: Needs to reject non teacher/schooladmins
  def create
    begin
      reward_deliveries = RewardDelivery.find(params[:reward_deliveries])
    rescue
      flash[:notice] = "Nothing marked for delivery"
      on_success and return
    end
    command = DeliverRewardsCommand.new reward_deliveries: reward_deliveries
    #command.on_success = method(:on_success)
    command.execute!
    MixPanelTrackerWorker.perform_async(current_user.id, 'Mark Item as Delivered', mixpanel_options)
    redirect_to purchases_report_path(params)
  end

  def on_success
    redirect_to purchases_report_path(params)
  end

  def undeliver
    reward_delivery = RewardDelivery.find(params[:reward_delivery_id])
    render :json => {success: reward_delivery.undeliver}
  end
end
