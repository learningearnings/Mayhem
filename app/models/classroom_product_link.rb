class ClassroomProductLink < ActiveRecord::Base
  attr_accessible :classroom_id, :spree_product_id

  belongs_to :spree_product
  belongs_to :classroom
end
