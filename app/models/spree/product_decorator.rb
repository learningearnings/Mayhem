Spree::Product.class_eval do
  attr_accessible :store_ids

  has_one :spree_product_filter_link, :autosave => true
  has_one :filter, :through => :spree_product_filter_link


  def self.with_filter(filters = [1])
    joins(:filter).where(Filter.quoted_table_name => {:id => filters})
  end

  def thumb
    if images.first.present?
      images.first.attachment.url(:small)
    else
      "common/le_logo.png"
    end
  end

end
