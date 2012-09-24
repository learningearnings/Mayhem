Spree::Product.class_eval do
  attr_accessible :store_ids

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

end
