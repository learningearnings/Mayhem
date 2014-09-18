ActiveAdmin.register Auction do
  scope :active
  scope :ended
  scope :upcoming
  scope :unfulfilled
  config.filters = false

  controller do
    skip_before_filter :add_current_store_id_to_params
    with_role :le_admin

    def create
      @auction = Auction.new(params[:auction].except(:auction_zip_code_ids))
      @auction.creator = current_person
      if @auction.save
        create_auction_zip_codes
        flash[:notice] = 'Auction updated.'
        redirect_to admin_auction_path(@auction)
      else
        flash[:error] = 'There was a problem updating the auction.'
        render :edit
      end
    end

    def update
      @auction = Auction.find(params[:id])
      if @auction.update_attributes(params[:auction].except(:auction_zip_code_ids))
        create_auction_zip_codes
        @auction.auction_state_links.delete_all
        @auction.auction_school_links.delete_all
        flash[:notice] = 'Auction updated'
        redirect_to admin_auction_path(@auction)
      else
        flash[:error] = 'There was a problem updating the auction.'
        render :edit
      end
    end

    def fulfill_auction
      auction = Auction.find(params[:auction_id])
      auction.fulfill!
      redirect_to admin_auction_path(auction)
    end

    def create_auction_zip_codes
      @auction.auction_zip_codes.delete_all
      params[:auction][:auction_zip_code_ids].each do |zip|
        @auction.auction_zip_codes.create(:zip_code => zip) if zip.present?
      end
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
      link_html += (link_to "Edit", edit_admin_auction_path(auction)) + " " if auction.upcoming?
      link_html += (link_to "Delete", admin_auction_path(auction), method: :delete) + " " if auction.upcoming?
      link_html.html_safe
    end
    default_actions
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
      f.input :schools, :as => :chosen
      f.input :states, :as => :chosen
      f.input :auction_zip_codes, :as => :chosen, :collection => Address.pluck(:zip)
    end
    f.buttons
  end
end
