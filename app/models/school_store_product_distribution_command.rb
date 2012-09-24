require_relative 'active_model_command'

class SchoolStoreProductDistributionCommand < ActiveModelCommand

  validates_presence_of :master_product, :school, :quantity, :retail_price
  validates :quantity, :numericality => {:greater_than_or_equal_to => 0}
  validates :retail_price, :numericality => {:greater_than_or_equal_to => 0}

  attr_accessor :master_product, :school, :quantity, :retail_price, :spree_property_class


  def initialize params={}
    @master_product = params[:master_product]
    @school         = params[:school]
    @quantity       = params[:quantity]
    @retail_price   = params[:retail_price]
    @person         = params[:person]
  end

  def spree_property_class
    Spree::Property
  end

  def execute!
    retail_store = @school.store || return
    if retail_store.products.with_property_value('master_product',@master_product.id.to_s).exists?
      retail_product = retail_store.products.with_property_value('master_product',@master_product.id.to_s).first
      ### TODO - Is this legit?
      retail_product.taxons = @master_product.taxons
      retail_product.master.count_on_hand += @quantity.to_i
      retail_product.master.save
    else
      retail_price_property = spree_property_class.find_by_name('retail_price');
      retail_quantity_property = spree_property_class.find_by_name('retail_quantity');

      retail_product = @master_product.duplicate
      retail_product.name = master_product.name # need to set this to avoid "COPY OF ..."
      retail_product.master.price = @retail_price
      retail_product.description = @master_product.description
      retail_product.available_on = Time.now
      retail_product.deleted_at = nil
      retail_product.permalink = @school.store_subdomain + "-" + @master_product.permalink
      retail_product.master.count_on_hand = @quantity
      retail_product.product_properties.where(:property_id => retail_price_property.id).each do |p| p.destroy end
      retail_product.product_properties.where(:property_id => retail_quantity_property.id).each do |p| p.destroy end
      ### TODO - Is this legit?
      retail_product.taxons = @master_product.taxons

      retail_product.count_on_hand = @quantity
      retail_product.store_ids = [retail_store.id]
      retail_product.set_property('master_product',@master_product.id.to_s)
      retail_product.master.save # The master variant, not the master_product
      retail_product.save

      fc = FilterConditions.new(:schools => [@school.id])
      factory = FilterFactory.new
      filter = factory.find_or_create_filter(fc)

      SpreeProductFilterLink.create(:filter_id => filter.id, :product_id => retail_product.id)
      SpreeProductPersonLink.create(product_id: retail_product.id, person_id: @person.id)
      # currently only SchoolAdmin persons can call this method to add products to their school == retail
      retail_product.properties.create(name: "type", presentation: "retail")
    end
  end

end
