class Message < ActiveRecord::Base
  attr_accessible :from_id, :to_id, :subject, :body

  belongs_to :from, class_name: 'Person', foreign_key: :from_id
  belongs_to :to, class_name: 'Person', foreign_key: :to_id

  validates :from_id, presence: true, numericality: true
  validates :to_id,   presence: true, numericality: true
  validates :subject, presence: true
  validates :body,    presence: true

  state_machine :status, initial: :unread do
    event :read! do
      transition [:read, :unread] => :read
    end
    state :unread
    state :read
  end

  # Describe available canned messages here
  def self.canned_messages
    [
      "You're pretty swell, guy.",
      "You smell worse than my mom.",
      "I'm going to kill your family...with kindness."
    ]
  end
end
