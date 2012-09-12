Spree::Product.class_eval do
  attr_accessible :store_ids

  has_one :spree_product_filter_link
  has_one :filter, :through => :spree_product_filter_link


  def self.with_filter(filters = [1])
    joins(:filter).where(Filter.quoted_table_name => {:id => filters})
  end


end
