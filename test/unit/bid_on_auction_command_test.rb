require 'test_helper'
require_relative '../../app/models/bid_on_auction_command'

describe BidOnAuctionCommand do
  subject do
    command = BidOnAuctionCommand.new(person: person, auction: auction, amount: amount, credit_manager: credit_manager)
    command.stubs(:message_creator).returns(message_creator)
    # Make our transaction just execute stuff at present
    def command.transaction &block
      begin
        yield
      rescue ActiveRecord::Rollback
      end
    end
    command
  end
  let(:person){ mock("person") }
  let(:bid_leader){ mock("bid_leader") }
  let(:auction) do
    val = mock("auction")
    val.stubs(:current_bid).returns(BigDecimal('0'))
    val.stubs(:active?).returns(true)
    val.stubs(:current_leader).returns(bid_leader)
    val.stubs(:id).returns(1)
    val
  end

  let(:amount){ BigDecimal('5') }
  let(:credit_manager){ mock("credit manager") }
  let(:message_creator){ lambda{|params|} }

  describe ":validations:" do
    it 'has an auction' do
      subject.wont have_valid(:auction).when(nil)
      subject.must have_valid(:auction).when(auction)
    end

    it 'has a person' do
      subject.wont have_valid(:person).when(nil)
      subject.must have_valid(:person).when(person)
    end

    it 'has a credit_manager' do
      subject.wont have_valid(:credit_manager).when(nil)
      subject.must have_valid(:credit_manager).when(credit_manager)
    end

    it 'has a positive decimal amount' do
      subject.wont have_valid(:amount).when(nil)
      subject.wont have_valid(:amount).when('1')
      subject.wont have_valid(:amount).when(BigDecimal('0'))
      subject.wont have_valid(:amount).when(BigDecimal('-5'))
      subject.must have_valid(:amount).when(BigDecimal('1'))
    end

    it 'has an amount greater than the #current_bid on #auction' do
      auction.stubs(:current_bid).returns(BigDecimal('2'))
      subject.wont have_valid(:amount).when(BigDecimal('1'))
      subject.wont have_valid(:amount).when(BigDecimal('2'))
      subject.must have_valid(:amount).when(BigDecimal('2.01'))
    end
  end

  it "defers to :auction's #current_bid for #auction_current_bid" do
    amount = BigDecimal('13')
    auction.expects(:current_bid).returns(amount)
    subject.auction_current_bid.must_equal(amount)
  end

  describe "execution" do
    describe "success" do
      it "interacts with its collaborators properly on #execute!" do
        person1 = mock("person1")
        bid1 = mock("bid1")
        bid1.stubs(:person).returns(person1)
        bid1amount = BigDecimal('1')
        bid1.expects(:amount).returns(bid1amount)
        auction.stubs(:open_bids).returns([bid1])
        # Verify that we invalidate existing bids
        bid1.expects(:invalidate!)
        # Verify that we refund money on existing bids
        credit_manager.expects(:transfer_credits_from_hold_to_checking).with(person1, bid1amount)
        # Verify that we create a new bid
        bid_creator = mock("bid_creator")
        bid_creator.expects(:call).with(amount: amount, person: person, auction: auction)
        subject.stubs(:bid_creator).returns(bid_creator)
        # Verify that we move money on new bid from person's checking to hold
        credit_manager.expects(:transfer_credits_from_checking_to_hold).with(person, amount).returns(true)
        # Verify that we update the auction's current_bid to this amount
        auction.expects(:current_bid=).with(amount)
        auction.expects(:save!)
        # Verify that we call the on_success callback
        on_success = mock("on_success")
        on_success.expects(:call).with(subject)
        subject.on_success = on_success
        
        subject.execute!
      end

      it "calls on_failure if anything goes wrong in #execute" do
        subject.expects(:valid?).returns(false)
        on_failure = mock()
        on_failure.expects(:call).with(subject)
        subject.on_failure = on_failure

        subject.execute!
      end
    end

    describe "failure due to insufficient funds" do
      it 'calls on_failure' do
        person1 = mock("person1")
        auction.stubs(:open_bids).returns([])
        auction.stubs(:starting_bid).returns(BigDecimal('1'))
        # Verify that we create a new bid
        bid_creator = mock("bid_creator")
        bid_creator.expects(:call).with(amount: amount, person: person, auction: auction)
        subject.stubs(:bid_creator).returns(bid_creator)
        # Fail to move money on new bid from person's checking to hold
        credit_manager.expects(:transfer_credits_from_checking_to_hold).with(person, amount).returns(false)
        # Verify that we call the on_failure callback
        on_failure = mock("on_failure")
        on_failure.expects(:call).with(subject)
        subject.on_failure = on_failure
        
        subject.execute!
      end
    end
  end
end
