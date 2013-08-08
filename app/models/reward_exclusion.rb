class RewardExclusion < ActiveRecord::Base
  validates_presence_of :school_id, :product_id
  belongs_to :school
  belongs_to :product, class_name: "Spree::Product", foreign_key: :product_id
end
