require_relative 'active_model_command'

class SchoolStoreProductDistributionCommand < ActiveModelCommand

  validates_presence_of :master_product, :school, :quantity, :retail_price
  validates :quantity, :numericality => {:greater_than_or_equal_to => 0}
  validates :retail_price, :numericality => {:greater_than_or_equal_to => 0}

  attr_accessor :master_product, :school, :quantity, :retail_price, :spree_property_class
  attr_accessor :spree_product_filter_link_class, :spree_product_person_link_class
  attr_accessor :filter_conditions_class, :filter_factory_class, :spree_product_class, :spree_image_class

  def initialize params={}
    @master_product = params[:master_product]
    @school         = params[:school]
    @quantity       = params[:quantity]
    @retail_price   = params[:retail_price]
    @person         = params[:person]
  end

  def spree_property_class
    @spree_property_class || Spree::Property
  end

  def spree_product_filter_link_class
    @spree_product_filter_link_class || ::SpreeProductFilterLink
  end

  def spree_product_person_link_class
    @spree_product_person_link_class || ::SpreeProductPersonLink
  end

  def filter_conditions_class
    @filter_conditions_class || ::FilterConditions
  end

  def filter_factory_class
    @filter_factory_class || ::FilterFactory
  end

  def spree_image_class
    @spree_image_class || Spree::Image
  end

  def spree_product_class
    @spree_product_class || Spree::Product
  end

  def execute!
    retail_store = @school.store || return
    if retail_store.products.with_property_value('master_product', @master_product.id.to_s).exists?
      retail_product = retail_store.products.with_property_value('master_product', @master_product.id.to_s).first
      ### TODO - Is this legit?
      retail_product.taxons = @master_product.taxons
      retail_product.master.count_on_hand += @quantity.to_i
      retail_product.master.price = @retail_price
      retail_product.master.save
    else
      retail_price_property = spree_property_class.find_by_name('retail_price');
      retail_quantity_property = spree_property_class.find_by_name('retail_quantity');
      retail_product = spree_product_class.new()
      retail_product.name = master_product.name # need to set this to avoid "COPY OF ..."
      retail_product.master.price = @retail_price
      retail_product.description = @master_product.description
      retail_product.available_on = Time.now
      retail_product.deleted_at = nil
      retail_product.permalink = @school.store_subdomain + "-" + @master_product.permalink
      retail_product.master.count_on_hand = @quantity
      retail_product.shipping_category = Spree::ShippingCategory.find_by_name('In Classroom')
      ### TODO - Is this legit?
      retail_product.taxons = @master_product.taxons
      if @master_product && @master_product.master && @master_product.master.images[0]
        begin
          new_image = open(@master_product.master.images[0].attachment.url)
        rescue
          new_image = nil
        end
#       def new_image.original_filename; base_uri.path.split('/').last; end
        new_spree_image = spree_image_class.new({:viewable_id => retail_product.master.id,
                                                  :viewable_type => 'Spree::Variant',
                                                  :alt => "position 1",
                                                  :position => 1})
        if(new_image)
          new_spree_image.attachment = new_image
        end
        new_spree_image.save
        retail_product.master.images << new_spree_image
      end
      retail_product.count_on_hand = @quantity
      retail_product.fulfillment_type = 'School to Fulfill'
      retail_product.store_ids = [retail_store.id]
#      retail_product.master.save # The master variant, not the master_product
      retail_product.save
      retail_product.set_property('master_product',@master_product.id.to_s)

      retail_product.properties.create(name: "type", presentation: "retail")
    end
    retail_product
  end

end
