ActiveAdmin.register AuctionBid do
#  scope :open
#  scope :invalidated

  menu :parent => "Auctions"

  
  index do
    column :person do |auction_bid|
      auction_bid.person.name
    end
    column :auction do |auction_bid|
      auction_bid.auction.product.name
    end
    column :amount
    column :created_at
    column :updated_at
    column :status
  end

end