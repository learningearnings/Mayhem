require 'action_view'
require_relative '../../lib/job_logger.rb'

class AuctionHandler
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers
  include JobLogger
  attr_accessor :auctions

  def initialize
    @auctions = Auction.ended.not_notified
  end

  def run!
    job_started
    begin
      auctions.each do |auction|
        next if auction.current_leader.blank? || auction.creator.blank?
        notify_student_of_win(auction)
        notify_creator_of_auction_end(auction)
        auction.notify!
      end
    rescue => error
      job_failed_with_error(error)
    else
      job_ended
    end
  end

  private
  def notify_student_of_win(auction)
    body = "You've won the following auction: #{link_to(auction.to_s, Rails.application.routes.url_helpers.auction_path(auction))}."
    m = Message.create(
      from_id: auction.creator.id,
      to_id: auction.current_leader.id,
      subject: "You've won an auction",
      body: body,
      category: 'games'
    )
    puts m.errors.full_messages
  end

  def notify_creator_of_auction_end(auction)
    body = "The following auction has ended: #{link_to(auction.to_s, Rails.application.routes.url_helpers.auction_path(auction))}."
    Message.create(
      from_id: auction.current_leader.id,
      to_id: auction.creator.id,
      subject: "An auction has ended.",
      body: body,
      category: 'le_admin'
    )
  end
end
