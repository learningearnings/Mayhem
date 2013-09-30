class Post < ActiveRecord::Base
  attr_accessible :body, :filter_id, :person_id, :published_by, :status, :title, :type
  attr_accessible :body, :filter_id, :person_id, :published_by, :status, :title, :type, as: :admin
  belongs_to :person

  scope :most_recent, order("created_at DESC")
  scope :published, where(status: 'published')

  state_machine :status, initial: :submitted do
    event :publish do
      transition [:submitted] => :published
    end

    event :archive do
      transition [:published] => :archived
    end

    event :flag do
      transition [:submitted, :published] => :flagged
    end

    state :submitted
    state :flagged
    state :published
    state :archived
  end
end
