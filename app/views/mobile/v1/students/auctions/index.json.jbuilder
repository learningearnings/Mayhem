json.auctions @auctions do |auction|
    json.id auction.id
    if auction.product
	    json.name auction.product.name
	    json.description auction.product.description
	    json.thumb auction.product.thumb
    end
    if auction.current_bid
    	json.current_bid number_with_precision(auction.current_bid, precision: 2, delimiter: ',')
    end
    if auction.current_leader
      json.high_bidder auction.current_leader.name
      if auction.current_leader.avatar.present?
        json.high_bidder_avatar_url auction.current_leader.avatar.image.url
      end
    end
    json.ends_on l(auction.end_date)
    
 
end	

