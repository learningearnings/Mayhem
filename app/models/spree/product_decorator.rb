Spree::Product.class_eval do
  attr_accessible :store_ids, :fulfillment_type, :purchased_by, :min_grade, :max_grade, :visible_to_all
  has_attached_file :svg
  has_many :auctions

  has_many :plutus_transactions, :as => :commercial_document, :class_name => 'Plutus::Transaction'

  has_one :spree_product_filter_link, :inverse_of => :product
  has_one :filter, :through => :spree_product_filter_link, :inverse_of => :products

  has_one :spree_product_person_link, :inverse_of => :product
  has_one :person, :through => :spree_product_person_link, :inverse_of => :products

  has_many :state_product_links, :foreign_key => :spree_product_id
  has_many :states, :through => :state_product_links, :class_name => "::State"

  has_many :school_product_links, :foreign_key => :spree_product_id
  has_many :schools, :through => :school_product_links

  has_many :classroom_product_links, :foreign_key => :spree_product_id
  has_many :classrooms, :through => :classroom_product_links


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
  scope :above_min_grade, lambda {|grade| where("min_grade <= ? OR min_grade IS NULL", grade)}
  scope :below_max_grade, lambda {|grade| where("max_grade >= ? OR max_grade IS NULL", grade)}
  scope :no_min_grade, where("min_grade == ?", nil)
  scope :no_max_grade, where("max_grade == ?", nil)
  scope :shipped_for_school_inventory, where(:fulfillment_type => "Shipped for School Inventory")
  scope :not_shipped_for_school_inventory, where("fulfillment_type != ?", "Shipped for School Inventory")
  scope :not_local, where("fulfillment_type != ?", "local")
  scope :visible_to_all, where(:visible_to_all => true)
  scope :for_classroom, lambda {|classroom| joins({:classrooms => [:classroom_product_links]}).where("classroom_product_links.classroom_id = ?", classroom.id) }
  scope :active, where("deleted_at IS NULL")

  def self.with_filter(filters = [1])
    joins(:filter).where(Filter.quoted_table_name => {:id => filters})
  end

  def self.not_excluded(school)
    if(school.reward_exclusions.any?)
      where("spree_products.id NOT IN (?)", school.reward_exclusions.map(&:product_id))
    else
      scoped
    end
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

  def master_product
    if property('master_product')
      Spree::Product.find(property('master_product'))
    end
  end

  %w(images name description price).each do |delegated_attribute|
    define_method delegated_attribute do
      master_product ? master_product.send(delegated_attribute) : super
    end
  end
end
