ActiveAdmin.register Auction do
  scope :active
  scope :ended
  scope :upcoming

  controller do
    skip_before_filter :add_current_store_id_to_params
    with_role :le_admin

    def create
      options = params[:auction].dup
      options.delete(:auction_zip_code_ids)
      @auction = Auction.new(options)
      if @auction.save
        params[:auction][:auction_zip_code_ids].each do |zip|
          @auction.auction_zip_codes.create(:zip_code => zip) if zip.present?
        end
        flash[:notice] = 'Auction updated'
        redirect_to admin_auction_path(@auction)
      else
        flash[:error] = 'There was a problem updating the auction.'
        render :edit
      end
    end

    def update
      @auction = Auction.find(params[:id])
      @auction.auction_state_links.delete_all
      @auction.auction_school_links.delete_all
      @auction.auction_zip_codes.delete_all
      params[:auction][:auction_zip_code_ids].each do |zip|
        @auction.auction_zip_codes.create(:zip_code => zip) if zip.present?
      end
      params[:auction].delete(:auction_zip_code_ids)
      if @auction.update_attributes(params[:auction])
        flash[:notice] = 'Auction updated'
        redirect_to admin_auction_path(@auction)
      else
        flash[:error] = 'There was a problem updating the auction.'
        render :edit
      end
    end
  end

  index do
    column :id
    column :auction_type
    column :product do |auction|
      auction.product.name
    end
    column :start_date
    column :end_date
    column :status
    column :starting_bid do |auction|
      number_to_currency(auction.starting_bid)
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
      session[auction_session_key] = Time.zone.now

      bid_text += number_to_currency(auction.current_bid)
      bid_text.html_safe
    end
    column :leader do |auction|
      leader = auction.current_leader
      "#{leader} (#{leader.grade}) #{leader.school}" if leader
    end
    column :actions do |auction|
      link_html = ""
      link_html += (link_to "Show", admin_auction_path(auction)) + " " if auction.upcoming?
      link_html += (link_to "Edit", edit_admin_auction_path(auction)) + " " if auction.upcoming?
      link_html += (link_to "Delete", admin_auction_path(auction), method: :delete) + " " if auction.upcoming?
      link_html.html_safe
    end
  end

  show do |auction|
    attributes_table do
      row :id
      row :start_date
      row :end_date
      row :current_bid
      row :product
      row :auction_type
      row :starting_bid
      row :min_grade
      row :max_grade
      row :states do
        auction.states.collect{|t| t.name}.join(', ')
      end
      row :schools do
        auction.schools.collect{|t| t.name}.join(', ')
      end
      row :auction_zip_codes do
        auction.auction_zip_codes.collect{|t| t.zip_code}.join(', ')
      end
 
    end
    render 'links'
  end

  form do |f|
    f.inputs "Details" do
      f.input :product
      f.input :start_date, :as => :datepicker
      f.input :end_date, :as => :datepicker
      f.input :min_grade, :as => :select, :collection => School::GRADES
      f.input :max_grade, :as => :select, :collection => School::GRADES
      f.input :schools, :as => :chosen
      f.input :states, :as => :chosen
      f.input :auction_zip_codes, :as => :chosen, :collection => Address.all.map{|x| x.zip}
    end
    f.buttons
  end
end
