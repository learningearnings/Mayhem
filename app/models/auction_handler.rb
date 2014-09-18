require 'action_view'

class AuctionHandler
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers
  attr_accessor :auctions

  def initialize
    @auctions = Auction.ended.not_notified
  end

  def run!
    # Even though an auction has many schools, they all, from what I can tell
    #  only have one school associated to them
    # For the time beings, will send the message from the first school admin
    #  and send notifications to the winner and all school admins
    auctions.each do |auction|
      winner = auction.current_leader
      school_admins = auction.schools.first.school_admins
      # If there is no school admin, we can't send the message
      next if school_admins.blank? || auction.product.blank?
      notify_student_of_win(auction, winner, school_admins.first)
      school_admins.each do |admin|
        notify_admin_of_auction_end(auction, admin, winner)
      end
      # auction.notify!
    end
  end

  private
  def notify_student_of_win(auction, winner, school_admin)
    body = "You've won the following auction: #{link_to(auction.to_s, Rails.application.routes.url_helpers.auction_path(auction))}."
    m = Message.create(
      from_id: school_admin.id,
      to_id: winner.id,
      subject: "You've won an auction",
      body: body,
      category: 'games'
    )
    puts m.errors.full_messages
  end

  def notify_admin_of_auction_end(auction, admin, winner)
    body = "The following auction has ended: #{link_to(auction.to_s, Rails.application.routes.url_helpers.auction_path(auction))}."
    Message.create(
      from_id: winner.id,
      to_id: admin.id,
      subject: "An auction has ended.",
      body: body,
      category: 'le_admin'
    )
  end
end
