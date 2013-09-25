class AuctionsController < LoggedInController
  def new
    @products = get_products
    @auction = Auction.new
  end

  def index
    @auctions = []
    Auction.active.for_school(current_school).uniq.map{|x| @auctions << x}
    Auction.active.for_state(current_school.state).uniq.map{|x| @auctions << x}
    Auction.active.for_zip(current_school.zip).uniq.map{|x| @auctions << x}
    Auction.active.select{|x| x.global?}.uniq.map{|x| @auctions << x}
    @auctions = @auctions.uniq
    render locals: { auctions: @auctions }
  end

  def show
    begin
      auction = Auction.find(params[:id])
      rescue
        flash[:error] = "This auction has already ended."
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

  def cancel_school_auction
    @auction = Auction.find params[:id]
    @auction.open_bids.map{|bid| BidOnAuctionCommand.new(:credit_manager => CreditManager.new).invalidate_bid(bid)}
    @auction.update_attribute(:end_date, Time.now)
    redirect_to auctions_path
  end

  def create
    @auction = Auction.new(params[:auction])
    @auction.created_locally = true
    if @auction.save
      AuctionSchoolLink.create(:school_id => current_school.id, :auction_id => @auction.id)
      flash[:notice] = 'Auction created'
      redirect_to auctions_path
    else
      flash[:error] = 'There was a problem creating the auction.'
      render :new
    end
  end

  def get_products
    with_filters_params = params
    with_filters_params[:searcher_current_person] = current_person
    with_filters_params[:current_school] = current_school
    searcher = Spree::Config.searcher_class.new(with_filters_params)
    searcher.retrieve_products
  end
end
