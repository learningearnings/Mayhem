class SpreeProductPersonLink < ActiveRecord::Base
  attr_accessible :person_id, :product_id, :person, :product

  belongs_to :product, :class_name => Spree::Product
  belongs_to :person

  validates :person_id, :presence => true, :numericality => true
  validates :product_id, :presence => true, :numericality => true, :uniqueness => true

  ## TODO check to see if these are needed
  ## More validations - exists in table
  validates :person, :presence => true
  validates :product, :presence => true

end

