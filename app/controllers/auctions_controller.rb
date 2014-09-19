class AuctionsController < LoggedInController

  def index
    @auctions = Auction.viewable_for(current_person)
  end

  def show
    begin
      @auction = Auction.find(params[:id])
      @bid = BidOnAuctionCommand.new
    rescue
      flash[:error] = "This auction has already ended."
      redirect_to auctions_path and return
    end
  end
end
