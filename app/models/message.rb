class Message < ActiveRecord::Base
  belongs_to :from, class_name: 'Person', foreign_key: :from_id
  belongs_to :to, class_name: 'Person', foreign_key: :to_id

  validates :from_id, presence: true, numericality: true
  validates :to_id,   presence: true, numericality: true
  validates :subject, presence: true
  validates :body,    presence: true
end
