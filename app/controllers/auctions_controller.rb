class AuctionsController < LoggedInController
  def index
    auctions = Auction.active
    render locals: { auctions: auctions }
  end

  def show
    begin
      auction = Auction.find(params[:auction_id])
      rescue
        flash[:error] = "This auction has already ended."
        redirect_to auctions_path and return
    end
    bid = BidOnAuctionCommand.new
    render locals: { auction: auction, bid: bid }
  end
end
