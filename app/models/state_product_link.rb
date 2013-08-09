class StateProductLink < ActiveRecord::Base
  attr_accessible :spree_product_id, :state_id

  belongs_to :spree_product
  belongs_to :state
end
