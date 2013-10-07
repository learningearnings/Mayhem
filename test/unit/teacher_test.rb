require 'test_helper_with_rails'

describe Teacher do
  subject { Teacher.new }

  it "defaults can_distribute_credits to true" do
    subject.can_distribute_credits?.must_equal true
  end
end
