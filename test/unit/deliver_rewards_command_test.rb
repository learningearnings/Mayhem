require 'test_helper'
require_relative '../../app/models/deliver_rewards_command'

describe DeliverRewardsCommand do
  it "marks the RewardDeliveries it's given as delivered" do
    delivery1 = mock()
    delivery1.expects(:deliver!)
    delivery2 = mock()
    delivery2.expects(:deliver!)
    command = DeliverRewardsCommand.new(reward_deliveries: [delivery1, delivery2])
    command.execute!
  end

  it "calls the on success callback when it succeeds" do
    on_success = mock()
    on_success.expects(:call)
    command = DeliverRewardsCommand.new(reward_deliveries: [])
    command.on_success = on_success
    command.execute!
  end

  it "calls the on failure callback when it fails" do
    on_failure = mock()
    on_failure.expects(:call)
    failing_delivery = mock()
    failing_delivery.stubs(:deliver!).raises(StandardError)
    command = DeliverRewardsCommand.new(reward_deliveries: [failing_delivery])
    command.on_failure = on_failure
    command.execute!
  end
end
