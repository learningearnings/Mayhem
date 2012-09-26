require_relative '../../../app/models/active_model_command'

class CreateStoreProduct < ActiveModelCommand

  validates_presence_of :name, :description, :store_code, :quantity, :retail_price, :available_on, :image
  validates :quantity, :numericality => {:greater_than_or_equal_to => 0}
  validates :retail_price, :numericality => {:greater_than_or_equal_to => 0}

  attr_accessor :name, :store_id, :quantity, :retail_price, :available_on, :image

  def initialize params={}
    @name             = params[:name]
    @description      = params[:description]
    @school           = params[:school]
    @quantity         = params[:quantity]
    @retail_price     = params[:retail_price]
    @available_on     = params[:available_on]
    @deleted_at       = params[:deleted_at]
    @image            = params[:image]
    @filter           = params[:filter]
    @reward_type      = params[:reward_type] || 'reward' # global, local, charity, reward
    @reward_owner     = params[:reward_owner] || @school.school_admins.first
  end

  def spree_image_class
    Spree::Image
  end

  def spree_store_class
    Spree::Store
  end

  def spree_product_class
    Spree::Product
  end

  def spree_product_filter_link_class
    SpreeProductFilterLink
  end

  def spree_product_person_link_class
    SpreeProductPersonLink
  end

  def le_admin_class
    LeAdmin
  end

  def school_store_product_distribution_command_class
    SchoolStoreProductDistributionCommand
  end


  # TODO Properties - Smarter reward creation
  #


  def execute!
    store = spree_store_class.find_by_code(@school.store_subdomain)
    return if store.nil?
    if @reward_type == 'reward'
      le_store = spree_store_class.find_by_code('le')
      wholesale_product = le_store.products.find_by_permalink(@name.parameterize)
      # do the copy and return the product if master_product
      if wholesale_product
        retail_price_property = spree_property_class.find_by_name('retail_price');
        retail_quantity_property = spree_property_class.find_by_name('retail_quantity');
        retail_price = retail_product.product_properties.where(:property_id => retail_price_property.id).first
        retail_price = retail_product.product_properties.where(:property_id => retail_price_property.id).first
        product = school_store_product_distribution_command_class.new(:master_product => wholesale_product,
                                                                      :school => @school,
                                                                      :quantity => retail_qty,
                                                                      :person => @reward_owner,
                                                                      :retail_price => retail_price
                                                                      ).execute!
        return product
      end
    end

    if @reward_type == 'global'
      product = spree_product_class.find_by_permalink(@name.parameterize)
      if product
        product.stores << store
        product.save
        return product
      else
        @reward_owner = le_admin_class.first
      end
    end

    product = spree_product_class.new
    product.name = @name
    product.description = @description
    product.permalink = @name.parameterize
    product.price = @retail_price
    product.master.price = @retail_price
    product.stores << store
    product.available_on = @available_on
    product.deleted_at = @deleted_at if @deleted_at
    product.count_on_hand = 100  #TODO - better quantity stuff
#    product.properties.create(name: "type", @reward_type)

    new_image = open('http://learningearnings.com/images/rewardimage/' + @image)
    def new_image.original_filename; base_uri.path.split('/').last; end
    new_spree_image = spree_image_class.new({:viewable_id => product.master.id,
                                              :viewable_type => 'Spree::Variant',
                                              :alt => "position 1",
                                              :position => 1})
    new_spree_image.attachment = new_image
    new_spree_image.save
    product.master.images << new_spree_image

    if @filter.nil?
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new schools: [@school], states: [@school.addresses[0].state.id]
      @filter = filter_factory.find_or_create_filter(filter_condition)
    end
    link = product.spree_product_filter_link || spree_product_filter_link_class.new(:product_id => product.id, :filter_id => @filter.id)
    link.filter_id = @filter.id
    product.spree_product_filter_link = link

    product.spree_product_person_link = spree_product_person_link_class.new(product_id: product.id, person_id: @reward_owner.id) if product && @reward_owner
    product.save
    product
  end





end
