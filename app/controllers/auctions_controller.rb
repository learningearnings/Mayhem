class AuctionsController < LoggedInController

  def index
    @auctions = available_auctions
    @tracker.track(current_user.id, 'View Auctions')
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
