ActiveAdmin.register Auction do
  scope :active
  scope :ended
  scope :upcoming
  scope :unfulfilled
  config.filters = false
  config.action_items.delete_if { |item|
    item.display_on?(:show)
  }
  action_item only: :show do
   link_to I18n.t('active_admin.edit'), edit_resource_path(resource) 
  end
  controller do
    skip_before_filter :add_current_store_id_to_params
    with_role :le_admin

    def create
      auction_creator = AuctionCreator.new(params[:auction].except(:auction_zip_code_ids), current_person)
      auction_creator.execute!
      if auction_creator.created?
        flash[:notice] = 'Auction created.'
        redirect_to admin_auction_path(auction_creator.auction)
      else
        flash[:error] = 'There was a problem updating the auction.'
        render :edit
      end
    end
    
    def new
      @auction = Auction.new
      @auction.schools = []
    end

    def index
      index! do |format|
        @auctions = Auction.where("deleted_at IS ?", nil).page(params[:page]).order("created_at DESC")
        format.html
      end 
    end

    def update
      @auction = Auction.find(params[:id])
      @auction.auction_zip_codes.delete_all
      @auction.auction_state_links.delete_all
      @auction.auction_school_links.delete_all
      if @auction.update_attributes(params[:auction].except(:auction_zip_code_ids))
        create_school_links
        create_auction_zip_codes
        create_state_links
        flash[:notice] = 'Auction updated'
        redirect_to admin_auction_path(@auction)
      else
        flash[:error] = 'There was a problem updating the auction.'
        render :edit
      end
    end
    
    def create_school_links
      school_ids = params[:auction][:school_ids]
      Rails.logger.debug("AKT: Create School Links: #{school_ids.inspect}")
      school_ids.each do | school_id |
        school = School.where(id: school_id).first
        AuctionSchoolLink.create(:school_id => school.id, :auction_id => @auction.id) if school
      end
    end
    
    def create_auction_zip_codes
      if params[:auction][:auction_zip_code_ids]
        params[:auction][:auction_zip_code_ids].each do |zip|
          zip = zip.strip
          AuctionZipCode.create(:zip_code => zip, :auction_id => @auction.id) if zip.present?
        end
      end
    end  
    
    def create_state_links
      if params[:auction][:state_ids]
        params[:auction][:state_ids].each do |state|
          state = state.strip
          AuctionStateLink.create(:state_id => state, :auction_id => @auction.id) if state.present?
        end    
      end
    end
  
    def fulfill_auction
      auction = Auction.find(params[:auction_id])
      auction.fulfill!
      redirect_to admin_auction_path(auction)
    end

    def cancel_auction
      auction = Auction.find(params[:id])
      auction.open_bids.map{|bid| BidOnAuctionCommand.new(:credit_manager => CreditManager.new).invalidate_bid(bid)}
      auction.update_attribute(:end_date, Time.now)
      redirect_to admin_auctions_path
    end

    def create_auction_zip_codes
      @auction.auction_zip_codes.delete_all
      params[:auction][:auction_zip_code_ids].each do |zip|
        @auction.auction_zip_codes.create(:zip_code => zip) if zip.present?
      end
    end

    def remove_auction
      @auction = Auction.find(params[:id])
      @auction.deleted_at = Time.now
      @auction.audit_logs.create(person_id: current_person.id, action: "Deactivate")
      @auction.save
      redirect_to admin_auctions_path
    end

  end

  index do
    column :id
    column :auction_type
    column :product do |auction|
      auction.product.name if auction.product
    end
    column :start_date
    column :end_date
    column :status
    column :starting_bid do |auction|
      auction.starting_bid if auction
    end
    column :bids do |auction|
      auction.auction_bids.count
    end
    column :bidders do |auction|
      auction.bidders.count
    end
    column :current_bid do |auction|
      bid_text = ""
      auction_session_key = "last_viewed_bid_time_for_auction_#{auction.id}"
      last_viewed_bid_time = session[auction_session_key]
      if last_viewed_bid_time
        difference = auction.bid_difference_since(last_viewed_bid_time)
        bid_text += "(+ #{difference}) " unless difference == BigDecimal('0')
      end

      bid_text += auction.current_bid.to_s
      bid_text.html_safe
    end

    column :leader do |auction|
      leader = auction.current_leader
      "#{leader} (#{leader.grade}) #{leader.school}" if leader
    end
    column :actions do |auction|
      link_html = ""
      link_html += (link_to "Show", admin_auction_path(auction)) + " "# if auction.upcoming?
      link_html += (link_to "Edit", edit_admin_auction_path(auction)) + " " 
      link_html += (link_to "Delete", admin_remove_auction_path(auction)) 
      link_html.html_safe
    end
    #default_actions
  end

  show do
    @auction = Auction.find(params[:id])
    render :partial => 'admin/auctions/show', :locals => { :auction => @auction }
  end

  form do |f|
    f.inputs "Details" do
      f.input :product, :as => :chosen, :collection => Spree::Product.for_auctions
      f.input :starting_bid
      f.input :start_date, :as => :just_datetime_picker
      f.input :end_date, :as => :just_datetime_picker
      f.input :min_grade, :as => :select, :collection => School::GRADES
      f.input :max_grade, :as => :select, :collection => School::GRADES
      f.input :schools, :as => :chosen, :collection => School.order('name ASC').map{|school| ["[#{school.id}]  #{school.name}", school.id]}
      f.input :states, :as => :chosen
      f.input :auction_zip_codes, :as => :chosen, :collection => School.all.collect { | school | school.zip }.uniq
    end
    f.buttons
  end
end
