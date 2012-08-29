class Post < ActiveRecord::Base
  attr_accessible :body, :filter_id, :person_id, :published_by, :status, :title, :type
  belongs_to :person

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
