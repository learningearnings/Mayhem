class Sticker < ActiveRecord::Base
  image_accessor :image
  belongs_to :school
  has_many :sticker_purchases
  has_one :product, class_name: "Spree::Product", foreign_key: :sticker_id

  attr_accessible :image, :min_grade, :max_grade, :school_id, :purchasable, :price, as: [:default, :admin]

  delegate :price, to: :product

  scope :unpurchasable, where(purchasable: false)

  def self.available_for_school_and_person(school, person)
    arel_table = self.arel_table
    available_stickers = Sticker.unpurchasable.
    where(
      arel_table[:school_id].eq(nil).
      or(
        arel_table[:school_id].eq(school.id)
      )
    ).where(
      arel_table[:min_grade].eq(nil).
      and(
        arel_table[:max_grade].eq(nil)
      ).
      or(
        arel_table[:min_grade].lteq(person.grade).
        and(arel_table[:max_grade].gteq(person.grade))
      )
    )
    purchased_stickers = person.sticker_purchases.not_expired.map(&:sticker)
    # Return the available + purchases stickers
    (available_stickers + purchased_stickers).uniq
  end

  def price=(value)
    product.price = value
    product.save

  end  
end
