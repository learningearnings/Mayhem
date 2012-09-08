require_relative 'active_model_command'

class DeliverRewardsCommand < ActiveModelCommand
  attr_accessor :on_success, :on_failure

  def initialize params={}
    # Set callbacks to no-ops
    @on_success = lambda{}
    @on_failure = lambda{}
    @reward_deliveries = params[:reward_deliveries]
  end

  def execute!
    begin
      @reward_deliveries.map(&:deliver!)
    rescue
      return on_failure.call
    end
    on_success.call
  end
end
