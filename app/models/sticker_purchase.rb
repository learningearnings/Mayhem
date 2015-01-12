class StickerPurchase < ActiveRecord::Base
  attr_accessible :expires_at, :person_id, :sticker_id
  belongs_to :sticker
  belongs_to :person

  scope :expired, lambda { where( StickerPurchase.arel_table[:expires_at].eq(nil).or(StickerPurchase.arel_table[:expires_at].lteq(Time.zone.now))) }
  scope :expires_after, lambda { |time| where( StickerPurchase.arel_table[:expires_at].gt(time)) }
  scope :not_expired, lambda { expires_after(Time.zone.now) }
end