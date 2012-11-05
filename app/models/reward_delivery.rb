class RewardDelivery < ActiveRecord::Base
  attr_accessible :from_id, :to_id, :reward_id

  belongs_to :from, class_name: "Person", foreign_key: :from_id
  belongs_to :to,   class_name: "Person", foreign_key: :to_id
  belongs_to :reward, class_name: "Spree::LineItem", foreign_key: :reward_id

  validates :from_id,   presence: true
  validates :to_id,     presence: true
  validates :reward_id, presence: true

  state_machine :status, initial: :pending do
    state :pending
    state :delivered
    event :deliver do
      transition :pending => :delivered
    end
  end

  scope :pending,   where(status: 'pending')
  scope :delivered, where(status: 'delivered')
end
