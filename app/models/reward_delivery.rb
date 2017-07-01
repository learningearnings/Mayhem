class RewardDelivery < ActiveRecord::Base
  attr_accessible :from_id, :to_id, :reward_id

  belongs_to :from, class_name: "Person", foreign_key: :from_id
  belongs_to :to,   class_name: "Person", foreign_key: :to_id
  belongs_to :reward, class_name: "Spree::LineItem", foreign_key: :reward_id
  belongs_to :delivered_by, class_name: "Person", foreign_key: :delivered_by_id

  scope :order_by_student_last_name, lambda { order("people.last_name,reward_deliveries.created_at DESC") }
  scope :order_by_student_grade, lambda { order(:to => :grade) }
  scope :newest_orders, lambda { order("reward_deliveries.created_at DESC") }
  scope :oldest_orders, lambda { order("reward_deliveries.created_at ASC") }
  scope :between, lambda { |start_date, end_date| where(arel_table[:created_at].gteq(start_date)).where(arel_table[:created_at].lteq(end_date)) }
  scope :in_last_7_days, lambda { between(7.days.ago, Time.zone.now) }
  scope :rewards_between, lambda { |start_date, end_date| where('reward_deliveries.created_at >= ? AND reward_deliveries.created_at <= ?',start_date, end_date) }


  validates :from_id,   presence: true
  validates :to_id,     presence: true
  validates :reward_id, presence: true

  state_machine :status, initial: :pending do
    state :pending
    state :delivered
    state :refunded
    event :deliver do
      transition :pending => :delivered
    end
    event :undeliver do
      transition :delivered => :pending
    end
    event :refund do
      transition :pending => :refunded
    end
  end

  scope :pending,  where(status: 'pending')
  scope :delivered, where(status: 'delivered')
  scope :refunded, where(status: 'refunded')
  scope :except_refunded, lambda { where(self.arel_table[:status].not_eq('refunded'))}

  def refund_purchase
    Rails.logger.info("AKT: Refund purchase: #{self.reward.inspect}")
    if self.reward.order.payment.state != "void"
      self.reward.order.payment.void_transaction!
      self.refund
    else
      # if payment.state is already void, do not issue another refund
      return false
    end
  end

end
