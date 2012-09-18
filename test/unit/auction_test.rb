require 'test_helper_with_rails'

describe Auction do
  subject { Auction.new }

  describe ":validations:" do
    it "must have either a number for current_bid" do
      subject.wont have_valid(:current_bid).when('asdf')
      subject.must have_valid(:current_bid).when('1')
    end
    it "must start off at a current_bid of BigDecimal('0')" do
      subject.current_bid.must_equal(BigDecimal('0'))
    end
    it "must have a numeric product_id" do
      subject.wont have_valid(:product_id).when(nil)
      subject.wont have_valid(:product_id).when('asdf')
      subject.must have_valid(:product_id).when(1)
    end
    it "must have a valid auction_type" do
      subject.wont have_valid(:auction_type).when(nil)
      subject.wont have_valid(:auction_type).when('asdf')
      subject.must have_valid(:auction_type).when('traditional')
    end
    it "must have an end_date after start_date" do
      subject.start_date = "2012-02-01"
      subject.wont have_valid(:end_date).when("2012-01-01")
      subject.wont have_valid(:end_date).when("2012-02-01")
      subject.must have_valid(:end_date).when("2012-02-02")
    end
  end
end
