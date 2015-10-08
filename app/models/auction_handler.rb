require 'action_view'

class AuctionHandler
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers
  attr_accessor :auctions

  def initialize
    @auctions = Auction.ended.not_notified
  end

  def run!
    auctions.each do |auction|
      next if auction.current_leader.blank? || auction.creator.blank?
      auction_won auction
      notify_student_of_win(auction)
      notify_creator_of_auction_end(auction)
      auction.notify!
    end
    auctions.last
  end

  private
  
  def auction_won auction
 
    student = Student.where(id: auction.current_leader.id).first
    return unless student
    amount = auction.current_bid   
    
    # move student credits from hold back to checking
    cm = CreditManager.new
    cm.transfer_credits "Transfer from Hold to Checking", student.hold_account, student.checking_account, amount

    # purchase auction product
    cm.transfer_credits "Auction Won", student.checking_account, cm.main_account, amount, auction.product  

    #create RewardDelivery     
    #@order = Spree::Order.new
    #@order.save  
    #@order.add_variant(Spree::Variant.find(auction.product.master.id), 1)  
    #OneClickSpreeProductPurchaseCommand.new(@order, student, student.school, auction.creator.id).execute!
    #puts "AKT:  created order with id: #{@order.id} from_id: #{auction.creator.id}, to_id: #{student.id}"
    
  end
  
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
    m = Message.create(
      from_id: auction.current_leader.id,
      to_id: auction.creator.id,
      subject: "An auction has ended.",
      body: body,
      category: 'games'
    )
    puts m.errors.full_messages
  end
end
