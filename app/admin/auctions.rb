ActiveAdmin.register Auction do
  scope :active
  scope :ended
  scope :upcoming

  controller do
    skip_before_filter :add_current_store_id_to_params
    with_role :le_admin
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
      link_html += (link_to "Edit", edit_admin_auction_path(auction)) + " " if auction.upcoming?
      link_html += (link_to "Delete", admin_auction_path(auction), method: :delete) + " " if auction.upcoming?
      link_html.html_safe
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :product
      f.input :start_date
      f.input :end_date
    end
    f.buttons
  end
end
