class AuctionsController < LoggedInController

  def index
    @auctions = available_auctions
    #MixPanelTrackerWorker.perform_async(current_user.id, 'View Auctions', mixpanel_options)
  end

  def show
    @auction = Auction.find(params[:id])
    unless available_auctions.include?(@auction)
      redirect_to auctions_path and return
    end
  end

  private

  def available_auctions
    Auction.viewable_for(current_person)
  end
end
