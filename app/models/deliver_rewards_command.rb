require_relative 'active_model_command'

class DeliverRewardsCommand < ActiveModelCommand
  attr_accessor :on_success, :on_failure

  def initialize params={}
    # Set callbacks to no-ops
    @on_success = lambda{}
    @on_failure = lambda{}
    @reward_deliveries = params[:reward_deliveries]
    @current_person_id = params[:current_person_id]
  end

  def execute!
    begin
      @reward_deliveries.map(&:deliver!)
      @reward_deliveries.each do |r|
        r.delivered_by_id = @current_person_id
        r.save
      end

    rescue
      return on_failure.call
    end
    on_success.call
  end
end
