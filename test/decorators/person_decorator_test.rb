require 'test_helper'

describe PersonDecorator do
  before do
    ApplicationController.new.set_current_view_context
    # Provide a mock person that responds to the decorator's API interactions properly
    @person  = mock 'Person'
    @account = mock 'Account'
    @person.stubs(:account).returns(@account)
    @account.stubs(:balance).returns(100)
  end

  subject { PersonDecorator.new(@person) }

  it "knows the checking_balance" do
    subject.checking_balance.must_equal "$100.00"
  end

  it "knows the savings_balance" do
    # NOTE: This is faked to 0 right now regardless, this test needs updating when that changes
    subject.savings_balance.must_equal "$0.00"
  end
end
