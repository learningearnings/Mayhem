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
    @legacy_selector  = params[:legacy_selector]
    @quantity         = params[:quantity]
    @price            = params[:price]
    @retail_price     = params[:retail_price]
    @retail_quantity  = params[:retail_quantity]
    @available_on     = params[:available_on]
    @deleted_at       = params[:deleted_at]
    @image            = params[:image]
    @filter           = params[:filter]
    @reward_type      = params[:reward_type] || 'retail' # global, local, charity, retail, wholesale
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
    if @reward_type == 'wholesale'
      le_store = spree_store_class.find_by_code('le')
      wholesale_product = le_store.products.with_property_value('legacy_selector',@legacy_selector).first
      # do the copy and return the product if master_product
#      puts "#{@legacy_selector} Not found - must create" if !wholesale_product
      if wholesale_product
        wholesale_product = spree_product_class.find(wholesale_product.id)
        retail_price = wholesale_product.property('retail_price').to_f
        retail_qty = wholesale_product.property('retail_quantity').to_i
        product = school_store_product_distribution_command_class.new(:master_product => wholesale_product,
                                                                      :school => @school,
                                                                      :quantity => retail_qty,
                                                                      :person => @reward_owner,
                                                                      :retail_price => retail_price
                                                                      ).execute!
        return product
      end
    end

    if @reward_type == 'global' || @reward_type == 'charity'
      product = spree_product_class.with_property_value('legacy_selector',@legacy_selector).first
      if product
        product = spree_product_class.find(product.id)
        product.stores << store
        product.save
        return product
      else
#        puts "#{@legacy_selector} Not found - must create"
        @reward_owner = le_admin_class.first
      end
    end

    product = spree_product_class.new


    product.name = @name
    product.description = @description
    product.permalink = @name.parameterize
    product.price = @price
    product.master.price = @retail_price
    if @reward_type == 'wholesale' || @reward_type == 'global' || @reward_type == 'charity'
      product.stores << le_store if le_store
    else
      product.stores << store
    end
    if @reward_type == 'global' || @reward_type == 'charity'
      product.stores << store
    end

    product.available_on = @available_on
    product.deleted_at = @deleted_at if @deleted_at
    product.count_on_hand = 100  #TODO - better quantity stuff


    if @filter.nil?
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new schools: [@school], states: [@school.addresses[0].state.id]
      @filter = filter_factory.find_or_create_filter(filter_condition)
    end
    link = product.spree_product_filter_link || spree_product_filter_link_class.new(:product_id => product.id, :filter_id => @filter.id)
    link.filter_id = @filter.id
    product.spree_product_filter_link = link unless @reward_type == 'wholesale'

    product.spree_product_person_link = spree_product_person_link_class.new(product_id: product.id, person_id: @reward_owner.id) if product && @reward_owner
    product.save

    if @reward_type == 'wholesale'
      product.set_property('retail_price',@retail_price)
      product.set_property('retail_quantity',@retail_quantity)
    end
    product.set_property("product_type", @reward_type)
    product.set_property("legacy_selector", @legacy_selector)
    product.save

    new_image = open('http://learningearnings.com/images/rewardimage/' + @image)
    def new_image.original_filename; base_uri.path.split('/').last; end
    new_spree_image = spree_image_class.new({:viewable_id => product.master.id,
                                              :viewable_type => 'Spree::Variant',
                                              :alt => "position 1",
                                              :position => 1})
    new_spree_image.attachment = new_image
    new_spree_image.save
    product.master.images << new_spree_image
    product.save
    if @reward_type == 'wholesale'
      retail_price = product.property('retail_price').to_f
      retail_qty = product.property('retail_quantity').to_i
      retail_product = school_store_product_distribution_command_class.new(:master_product => product,
                                                                    :school => @school,
                                                                    :quantity => retail_qty,
                                                                    :person => @reward_owner,
                                                                    :retail_price => retail_price
                                                                    ).execute!
      product = retail_product if retail_product
    end
    product
  end
end
