class LockerStickerLink < ActiveRecord::Base
  belongs_to :locker
  belongs_to :sticker

  attr_accessible :x, :y

  validates :locker_id, presence: true, numericality: true
  validates :sticker_id, presence: true, numericality: true
  validates :x, presence: true, numericality: true
  validates :y, presence: true, numericality: true

  def sticker_image_url
    sticker.image.url
  end
end
