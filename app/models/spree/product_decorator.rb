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
    self.property("reward_type")
  end

  def is_charity_reward?
    self.property("reward_type") == "charity"
  end

  def is_global_reward?
    self.property("reward_type") == "charity"
  end

  def is_wholesale_reward?
    self.property("reward_type") == "wholesale"
  end

  def has_retail_properties?
    self.property("retail_price") || self.property("retail_quantity")
  end

  def has_no_retail_properties?
    !has_retail_properties?
  end

  def requires_wholesale_properties?
    store_ids.include?(Spree::Store.find_by_name("le").id) && has_no_retail_properties?
  end

  def retail_quantity
    self.property("retail_quantity")
  end

  def retail_price
    self.property("retail_price")
  end

  def remove_property property_name
    pid = properties.find_by_name(product_name)
    return false if pid.nil?
    pp = product_properties.find_by_property_id(pid.id)
    pp.destroy if pp
  end

end
