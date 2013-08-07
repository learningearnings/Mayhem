class AuctionsController < LoggedInController
  def index
    auctions = Auction.active.for_school(current_school).for_state(current_school.addresses.first.state).uniq
    render locals: { auctions: auctions }
  end

  def show
    begin
      auction = Auction.find(params[:id])
      rescue
        flash[:error] = "That auction doesn't exist."
        redirect_to auctions_path and return
    end
    bid = BidOnAuctionCommand.new
    render locals: { auction: auction, bid: bid }
  end

  def cancel_auction
    @auction = Auction.find params[:id]
    @auction.open_bids.map{|bid| BidOnAuctionCommand.new(:credit_manager => CreditManager.new).invalidate_bid(bid)}
    @auction.update_attribute(:end_date, Time.now)
    redirect_to admin_auctions_path
  end
end
