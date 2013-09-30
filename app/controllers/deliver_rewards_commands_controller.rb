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
    command.on_success = method(:on_success)
    command.execute!
  end

  def on_success
    redirect_to purchases_report_path(params)
  end
end
