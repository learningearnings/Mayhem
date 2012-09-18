class AuctionsController < LoggedInController
  def index
    auctions = Auction.active
    render 'index', locals: { auctions: auctions }
  end
end
