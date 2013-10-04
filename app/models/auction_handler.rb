class AuctionHandler

  def intitialize
    @auctions = Auction.ended.not_notified
  end

  def run!
    @auctions.each do |auction|

    end 
  end

  def notify_of_win(auction)
    body = "You've won the following auction: #{link_to(auction.to_s, auction_path(auction))}."

    message_creator.call(from: person,
                         to: auction.current_leader,
                         subject: "You've won an auction",
                         body: body,
                         category: 'system')
  end


end
