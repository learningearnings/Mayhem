require 'test_helper_with_rails'

describe RewardDelivery do
  subject { RewardDelivery.new }

  it 'starts off in a pending state' do
    subject.must_be :pending?
  end

  it 'can be delivered' do
    @delivery = FactoryGirl.create(:reward_delivery)
    @delivery.deliver!
    @delivery.must_be :delivered?
  end

  it 'requires a from' do
    subject.wont have_valid(:from_id).when(nil)
    subject.must have_valid(:from_id).when(1)
  end

  it 'requires a to' do
    subject.wont have_valid(:to_id).when(nil)
    subject.must have_valid(:to_id).when(1)
  end

  it 'requires a reward' do
    subject.wont have_valid(:reward_id).when(nil)
    subject.must have_valid(:reward_id).when(1)
  end
end
