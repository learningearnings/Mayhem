class Locker < ActiveRecord::Base
  belongs_to :person
  has_many :locker_sticker_links

  validates :person_id, presence: true

  # Add a sticker to the locker
  def <<(sticker)
    link = self.locker_sticker_links.new
    link.sticker = sticker
    link.x = 0
    link.y = 0
    link.save
    link
  end
end
