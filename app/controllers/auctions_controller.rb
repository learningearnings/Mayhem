class AuctionsController < LoggedInController
  def new
    @products = get_products
    @auction = Auction.new
  end

  def create_auction_reward
    Rails.logger.warn("AUCTION REWARD PARAMS: #{params.inspect}")
    redirect_to new_auction_path, :notice => "Done"
  end

  def index
    school_auctions = Auction.active.for_school(current_school)
    state_auctions  = Auction.active.for_state(current_school.state)
    zip_auctions    = Auction.active.for_zip(current_school.zip)
    grade_auctions  = Auction.active.within_grade(current_person.grade)
    no_min_grade_auctions = Auction.active.no_min_grade
    no_max_grade_auctions = Auction.active.no_max_grade
    # Union of inclusive bits (school, state, zip)
    @auctions = school_auctions | state_auctions | zip_auctions
    # Intersection with the filters (grades)
    @auctions = (@auctions + grade_auctions + no_min_grade_auctions + no_max_grade_auctions).uniq
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
    @auction.start_date = Chronic.parse(params[:auction][:start_date])
    @auction.end_date = Chronic.parse(params[:auction][:end_date])
    if @auction.save
      AuctionSchoolLink.create(:school_id => current_school.id, :auction_id => @auction.id)
      flash[:notice] = 'Auction created'
      redirect_to auctions_path
    else
      @products = get_products
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
