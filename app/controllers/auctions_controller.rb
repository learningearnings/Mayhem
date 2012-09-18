class AuctionsController < LoggedInController
  def index
    auctions = Auction.active
    render locals: { auctions: auctions }
  end

  def show
    auction = Auction.find(params[:id])
    bid = BidOnAuctionCommand.new
    render locals: { auction: auction, bid: bid }
  end
end
