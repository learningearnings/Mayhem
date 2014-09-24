module SchoolAdmins
  class AuctionsController < SchoolAdmins::BaseController
    def index
      @auctions = Auction.viewable_for(current_person)
    end

    def edit
      begin
        @auction = Auction.find(params[:id])
      rescue
        flash[:error] = "This auction has already ended."
        redirect_to school_admins_auctions_path and return
      end
    end

    def new
      @products = current_school.products.for_auctions
      @auction = Auction.new
    end

    def create
      auction_creator = AuctionCreator.new(params[:auction], current_person)
      auction_creator.execute!
      if auction_creator.created?
        flash[:notice] = 'Auction created'
        redirect_to school_admins_auctions_path
      else
        @products = current_school.products.for_auctions
        @auction = auction_creator.auction
        flash[:error] = 'There was a problem creating the auction.'
        render :new
      end
    end

    def update
      @auction = Auction.find(params[:id])
      if @auction.update_attributes(params[:auction])
        flash[:notice] = 'The auction has been updated.'
        redirect_to @auction
      else
        flash[:error] = 'There was a problem updating the auction.'
        render :edit
      end
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
        redirect_to new_school_admins_auction_path
      else
        flash[:error] = "Auction Reward Failed To Create!"
        redirect_to new_school_admins_auction_path
      end
    end

    def cancel_school_auction
      @auction = Auction.find params[:id]
      @auction.open_bids.map{|bid| BidOnAuctionCommand.new(:credit_manager => CreditManager.new).invalidate_bid(bid)}
      @auction.update_attribute(:end_date, Time.now)
      flash[:notice] = "Auction cancelled."
      redirect_to school_admins_auctions_path
    end
  end
end
