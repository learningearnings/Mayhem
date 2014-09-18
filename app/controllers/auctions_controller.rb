class AuctionsController < LoggedInController
  def new
    @products = current_school.products.for_auctions
    @auction = Auction.new
  end

  def create_auction_reward
    p = Spree::Product.new
    p.fulfillment_type = "Auction Reward"
    p.name = params[:auction_reward_name]
    p.description = params[:auction_reward_description]
    p.price = BigDecimal.new("500.0") # The price is set, because of price validations in Spree::Product
    if p.save
      p.images.create(attachement: params[:auction_reward_image]) if params[:auction_reward_image].present?
      p.schools << current_school
      flash[:notice] = "Auction Reward Created!"
      redirect_to new_auction_path
    else
      flash[:error] = "Auction Reward Failed To Create!"
      redirect_to new_auction_path
    end
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
    @auction.creator = current_person
    @auction.created_locally = true
    @auction.start_date = Chronic.parse(params[:auction][:start_date])
    @auction.end_date = Chronic.parse(params[:auction][:end_date])
    if @auction.save
      AuctionSchoolLink.create(:school_id => current_school.id, :auction_id => @auction.id)
      flash[:notice] = 'Auction created'
      redirect_to auctions_path
    else
      @products = current_school.products.for_auctions
      flash[:error] = 'There was a problem creating the auction.'
      render :new
    end
  end
end
