class Mobile::V1::Students::AuctionsController < Mobile::V1::Students::BaseController
  def index
    current_person = Student.find(181357)
    @auctions = Auction.viewable_for(current_person)
    MixPanelTrackerWorker.perform_async(current_person.user.id, 'View Auctions', mixpanel_options)
  end

  def bid
    current_person = Student.find(181357)    
    if params[:id].blank? or params[:amount].blank?
      @msg = " You must supply an id and amount to bid on an auction"
      render json: { status:  :unprocessible_entity, msg: @msg} and return
    end
    auction = Auction.find(params[:id])
    amount = SanitizingBigDecimal(params[:amount])

    bid = BidOnAuctionCommand.new({ auction: auction, person: current_person, amount: amount, credit_manager: CreditManager.new })
    bid.on_success = method(:on_success)
    bid.on_failure = method(:on_failure)
    bid.execute!
  end 

  def on_success(bid)
    @msg = "Bid successful!"
    render json: { status:  :ok, msg: @msg} 
  end

  def on_failure(bid)
    @msg = bid.failure_reason.to_s.downcase.capitalize
    render json: { status:  :unprocessible_entity, msg: @msg} 
  end  
  
end
