require_relative 'active_model_command'

class SchoolStoreProductDistributionCommand < ActiveModelCommand

  validates_presence_of :master_product, :school, :quantity, :retail_price
  validates :quantity, :numericality => {:greater_than_or_equal_to => 0}
  validates :retail_price, :numericality => {:greater_than_or_equal_to => 0}

  attr_accessor :master_product, :school, :quantity, :retail_price


  def initialize params={}
    @master_product = params[:master_product]
    @school         = params[:school]
    @quantity        = params[:quantity]
    @retail_price   = params[:retail_price]
  end

  def execute!
    retail_store = Spree::Store.find_by_code(@school.id.to_s)
    if retail_store.products.with_property_value('master_product',@master_product.id.to_s).exists?
      retail_product = retail_store.products.with_property_value('master_product',@master_product.id.to_s).first
      ### TODO - Is this legit?
      retail_product.taxons = @master_product.taxons
      retail_product.master.count_on_hand += @quantity.to_i
      retail_product.master.save
    else
      retail_price_property = Spree::Property.find_by_name('retail_price');
      retail_quantity_property = Spree::Property.find_by_name('retail_quantity');

      retail_product = @master_product.duplicate
      retail_product.name = @master_product.name # need to set this to avoid "COPY OF ..."
      retail_product.master.price = @retail_price
      retail_product.description = @master_product.description
      retail_product.available_on = Time.now
      retail_product.deleted_at = nil
      retail_product.permalink = @school.id.to_s + "-" + @master_product.permalink
      retail_product.meta_description = ""
      retail_product.meta_keywords = ""
      retail_product.tax_category_id = nil
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
      end
  end
end
