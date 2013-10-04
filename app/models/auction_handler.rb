class AuctionHandler

  def intitialize params={}
    params ||= {}
    @auctions = Auction.ended.not_notified
    @admin = LeAdmin.first
  end

  def run!
    @auctions.each do |auction|
      notify_student_of_win(auction)
      notify_admin_of_auciton_end(auction)
      auction.notify!
    end 
  end

  def notify_student_of_win(auction)
    body = "You've won the following auction: #{link_to(auction.to_s, auction_path(auction))}."
    message_creator.call(from: @admin,
                         to: auction.current_leader,
                         subject: "You've won an auction",
                         body: body,
                         category: 'system')
  end

  def notify_admin_of_auciton_end(auction)
    body = "The following auction has ended: #{link_to(auction.to_s, auction_path(auction))}."
    message_creator.call(from: auction.current_leader,
                         to: @admin,
                         subject: "An auction has ended.",
                         body: body,
                         category: 'system')
  end

  def message_creator
    ->(params) { Message.create params }
  end

end
