ActiveAdmin.register Auction do
  scope :active
  scope :ended

  controller do
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
    column :bids do |auction|
      auction.auction_bids.count
    end
    column :bidders do |auction|
      auction.bidders.count
    end
    column :status
    column :current_bid
    column :leader do |auction|
      auction.current_leader
    end
    column :actions do |auction|
      link_html = ""
      link_html += (link_to "Edit", edit_admin_auction_path(auction)) + " " if auction.yet_to_begin?
      link_html += (link_to "Delete", admin_auction_path(auction), method: :delete) + " " if auction.yet_to_begin?
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
