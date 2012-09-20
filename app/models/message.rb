class Message < ActiveRecord::Base

  paginates_per 4
  attr_accessible :from_id, :to_id, :subject, :body, :category, :from, :to

  belongs_to :from, class_name: 'Person', foreign_key: :from_id
  belongs_to :to, class_name: 'Person', foreign_key: :to_id

  has_many :message_images, :through => :message_image_links
  has_many :message_image_links
  has_many :otu_codes, :through => :message_code_links
  has_many :message_code_links

  validates :from_id,  presence: true, numericality: true
  validates :to_id,    presence: true, numericality: true
  validates :subject,  presence: true
  validates :body,     presence: true
  validates :category, presence: true, inclusion: { in: lambda{ |o| Message.categories } }

  scope :unread,  where(status: 'unread')
  scope :read,    where(status: 'read')
  scope :not_hidden,  lambda { where("status != ?", 'hidden') }

  scope :from_friend,  where(category: 'friend')
  scope :from_system,  where(category: 'system')
  scope :from_teacher, where(category: 'teacher')
  scope :from_school,  where(category: 'school')
  scope :for_admin,    where(category: 'le_admin')

  state_machine :status, initial: :unread do
    event :read! do
      transition [:read, :unread] => :read
    end
    event :hide  do
      transition :read => :hidden
    end
    state :unread
    state :read
    state :hidden
  end

  # Describe available canned messages here
  def self.canned_messages
    [
      "You're pretty swell, guy.",
      "You smell worse than my mom.",
      "I'm going to kill your family...with kindness."
    ]
  end

  def self.categories
    [
      "friend",
      "school",
      "teacher",
      "system",
      "le_admin"
    ]
  end
end
