class BidOnAuctionCommandsController < LoggedInController
  def create
    begin
      auction = Auction.find(params[:auction_id])
      rescue
        flash[:error] = "This auction doesn't exist."
        redirect_to auctions_path and return
    end
    person = current_person
    amount = BigDecimal(params[:amount])
    bid = BidOnAuctionCommand.new({ auction: auction, person: person, amount: amount, credit_manager: CreditManager.new })
    bid.on_success = method(:on_success)
    bid.on_failure = method(:on_failure)
    bid.execute!
  end

  def on_success(bid)
    flash[:notice] = "Bid successful!"
    redirect_to bid.auction
  end

  def on_failure(bid)
    flash[:error] = bid.failure_reason.to_s.downcase.capitalize
    redirect_to bid.auction
  end
end
