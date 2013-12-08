require 'action_view'

class AuctionHandler
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers
  attr_accessor :auctions

  def initialize params={}
    params ||= {}
    @auctions = Auction.ended.not_notified
    @admin = LeAdmin.first
  end

  def run!
    @auctions.each do |auction|
      if auction.product.present?
        notify_student_of_win(auction)
        notify_admin_of_auction_end(auction)
        auction.notify!
      end
    end 
  end

  private
  def notify_student_of_win(auction)
    body = "You've won the following auction: #{link_to(auction.to_s, Rails.application.routes.url_helpers.auction_path(auction))}."
    message_creator.call(from: @admin,
                         to: auction.current_leader,
                         subject: "You've won an auction",
                         body: body,
                         category: 'games')
  end

  def notify_admin_of_auciton_end(auction)
    body = "The following auction has ended: #{link_to(auction.to_s, Rails.application.routes.url_helpers.auction_path(auction))}."
    message_creator.call(from: auction.current_leader,
                         to: @admin,
                         subject: "An auction has ended.",
                         body: body,
                         category: 'le_admin')
  end

  def message_creator
    ->(params) { Message.create params }
  end

end
