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
  
  def cleanup_expired_purchases!
    expired_sticker_ids = person.sticker_purchases.expired.pluck(:sticker_id) - person.sticker_purchases.not_expired.pluck(:sticker_id)
    locker_sticker_links.where(sticker_id: expired_sticker_ids).destroy_all
  end  
end
