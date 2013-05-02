Spree::Product.class_eval do
  attr_accessible :store_ids
  has_attached_file :svg

  has_many :plutus_transactions, :as => :commercial_document, :class_name => 'Plutus::Transaction'

  has_one :spree_product_filter_link, :inverse_of => :product
  has_one :filter, :through => :spree_product_filter_link, :inverse_of => :products

  has_one :spree_product_person_link, :inverse_of => :product
  has_one :person, :through => :spree_product_person_link, :inverse_of => :products

  #   # add_search_scope :with_property_value do |property, value|
  #   #   properties = Spree::Property.table_name
  #   #   conditions = case property
  #   #   when String   then ["#{properties}.name = ?", property]
  #   #   when Property then ["#{properties}.id = ?", property.id]
  #   #   else               ["#{properties}.id = ?", property.to_i]
  #   #   end
  #   #   conditions = ["#{ProductProperty.table_name}.value = ? AND #{conditions[0]}", value, conditions[1]]

  #   #   joins(:properties).where(conditions)
  #   # end

  # scope :le_with_property, lambda { |property|
  #     joins(:properties).where("#{Spree::Property.table_name}.name" => property)
  # }

  # scope :le_with_property_value, lambda { |property, value|
  #     le_with_property(property).joins(:properties).where("#{Spree::ProductProperty.table_name}.value" => value)
  # }


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
    self.property("reward_type") == "global"
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

  def reward_type
    self.property("reward_type")
  end


  def retail_quantity
    self.property("retail_quantity")
  end

  def retail_price
    self.property("retail_price")
  end

  def remove_property property_name
    pid = properties.find_by_name(property_name)
    return false if pid.nil?
    pp = product_properties.find_by_property_id(pid.id)
    pp.destroy if pp
  end

end
