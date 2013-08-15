class SchoolProductLink < ActiveRecord::Base
  attr_accessible :school_id, :spree_product_id

  belongs_to :spree_product
  belongs_to :school
end
