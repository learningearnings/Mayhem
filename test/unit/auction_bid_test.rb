require 'test_helper_with_rails'

describe AuctionBid do
  subject{ AuctionBid.new }

  describe ':validations:' do
    it 'has a numeric #auction_id' do
      subject.wont have_valid(:auction_id).when(nil)
      subject.wont have_valid(:auction_id).when('asdf')
      subject.must have_valid(:auction_id).when(1)
    end
    it 'has a numeric #person_id' do
      subject.wont have_valid(:person_id).when(nil)
      subject.wont have_valid(:person_id).when('asdf')
      subject.must have_valid(:person_id).when(1)
    end
    it 'has a BigDecimal and nonzero #amount' do
      subject.wont have_valid(:amount).when(nil)
      subject.wont have_valid(:amount).when(BigDecimal('0'))
      subject.wont have_valid(:amount).when(BigDecimal('-5'))
      subject.must have_valid(:amount).when(BigDecimal('1.0'))
    end
    it 'has a valid status' do
      subject.wont have_valid(:status).when(nil)
      subject.wont have_valid(:status).when('foo')
      subject.must have_valid(:status).when('open')
      subject.must have_valid(:status).when('invalidated')
    end
  end

  describe ":states:" do
    it "begins in an `open` state" do
      subject.status.must_equal 'open'
      subject.open?.must_equal true
    end

    it "transitions to an `invalidated` state with #invalidate!" do
      bid = FactoryGirl.create(:auction_bid)
      bid.invalidate!
      bid.status.must_equal 'invalidated'
    end
  end
end
