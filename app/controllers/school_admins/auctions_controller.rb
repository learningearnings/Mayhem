module SchoolAdmins
  class AuctionsController < SchoolAdmins::BaseController
    def index
      @auctions = Auction.active_for_school(current_school).order("end_date desc")
    end
    
    def all
      @auctions = Auction.for_school(current_school).where(" end_date < Now() ").order("end_date desc")
    end

    def edit
      begin
        @auction = Auction.find(params[:id])
        @products = current_school.products.for_auctions  
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
      auction_creator = AuctionCreator.new(params[:auction].merge(school_ids: [current_school.id]), current_person)
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
        @auction.update_attribute(:canceled, false)
        flash[:notice] = 'The auction has been updated.'
        redirect_to school_admins_auctions_path
      else
        @products = current_school.products.for_auctions 
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
        p.images.create(attachment: params[:auction_reward_image]) if params[:auction_reward_image].present?
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
      @auction.update_attribute(:canceled, true)
      @auction.audit_logs.create(person_id: current_person.id)
      flash[:notice] = "Auction cancelled."
      redirect_to school_admins_auctions_path
    end
    
    def delete_school_auction
      auction = Auction.find(params[:id])
      auction.open_bids.map{|bid| BidOnAuctionCommand.new(:credit_manager => CreditManager.new).invalidate_bid(bid)}
      auction.destroy
      flash[:notice] = "Auction permanently deleted."
      redirect_to school_admins_auctions_path
    end    
    
    
  end
end
