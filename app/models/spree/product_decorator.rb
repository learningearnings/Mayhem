Spree::Product.class_eval do
  attr_accessible :store_ids, :svg, :svg_file_name
  has_attached_file :svg

  has_one :spree_product_filter_link, :inverse_of => :product
  has_one :filter, :through => :spree_product_filter_link, :inverse_of => :products

  has_one :spree_product_person_link, :inverse_of => :product
  has_one :person, :through => :spree_product_person_link, :inverse_of => :products

  def self.with_filter(filters = [1])
    joins(:filter).where(Filter.quoted_table_name => {:id => filters})
  end

  def thumb
    images.first.attachment.url(:small)
  rescue
    "common/le_logo.png"
  end

  def has_property_type?
    properties.select{|s| s.name == "type" }.present?
  end

  def is_charity_reward?
    properties.select{|s| s.name == "type" && s.presentation == "charity"}.present?
  end

  def is_global_reward?
    properties.select{|s| s.name == "type" && s.presentation == "global"}.present?
  end

  def is_wholesale_reward?
    properties.select{|s| s.name == "type" && s.presentation == "wholesale"}.present?
  end

  def has_retail_properties?
    properties.select{|s| s.name == "retail_price" || s.name == "retail_quantity" }.present?
  end

  def has_no_retail_properties?
    !has_retail_properties?
  end

  def requires_wholesale_properties?
    store_ids.include?(Spree::Store.find_by_name("le").id) && has_no_retail_properties?
  end

  def retail_quantity
    properties.find_by_name("retail_quantity").product_properties.first.value rescue ''
  end

  def retail_price
    properties.find_by_name("retail_price").product_properties.first.value rescue ''
  end

end
