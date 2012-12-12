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
    @filter_id        = params[:filter_id]
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
    store = spree_store_class.find_by_code(@school.store_subdomain) if @school
    return if store.nil? && @school
    if @reward_type == 'wholesale'
      le_store = spree_store_class.find_by_code('le')
      wholesale_product = le_store.products.with_property_value('legacy_selector',@legacy_selector).first
      # do the copy and return the product if master_product
#      puts "#{@legacy_selector} Not found - must create" if !wholesale_product
      if wholesale_product && @school
        wholesale_product = spree_product_class.find(wholesale_product.id)
        retail_price = wholesale_product.property('retail_price').to_f
        retail_qty = wholesale_product.property('retail_quantity').to_i
        product = school_store_product_distribution_command_class.new(:master_product => wholesale_product,
                                                                      :school => @school,
                                                                      :quantity => retail_qty,
                                                                      :person => @reward_owner,
                                                                      :retail_price => retail_price
                                                                      ).execute!
        product.set_property('legacy_selector',@legacy_selector)
        return product
      elsif wholesale_product && @school.nil?
        return Spree::Product.find(wholesale_product.id)
      end
    end

    if @reward_type == 'global' || @reward_type == 'charity'
      product = spree_product_class.with_property_value('legacy_selector',@legacy_selector).first
      if product
        product = spree_product_class.find(product.id)
        product.store_ids |= [store.id]
        puts "(p1) ------------------------------------ Problem (#{product.errors.messages}) Saving product #{product.name} - #{product.properties.join(',')} for #{product.store_ids.join(',')}" if !product.save
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
      le_store = spree_store_class.find_by_code('le') if !le_store
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
    if @reward_type == 'charity'
      product.master.count_on_hand = 100000  #Charities have a nearly unlimited supply
    end

    if @filter_id.nil? && @reward_type == "wholesale"
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new :person_classes => ['LeAdmin', 'SchoolAdmin']
      filter = filter_factory.find_or_create_filter(filter_condition)
      @filter_id = filter.id
    elsif @filter_id.nil? && @school
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new schools: [@school], states: [@school.addresses[0].state]
      filter = filter_factory.find_or_create_filter(filter_condition)
      @filter_id = filter.id
    end
    link = product.spree_product_filter_link || spree_product_filter_link_class.new(:product_id => product.id, :filter_id => @filter_id)
    link.filter_id = @filter_id
    product.spree_product_filter_link = link

    product.spree_product_person_link = spree_product_person_link_class.new(product_id: product.id, person_id: @reward_owner.id) if product && @reward_owner
    if !product.save
      puts "(p2) ------------------------------------ Problem (#{product.errors.messages}) Saving product #{product.name} - #{product.properties.join(',')} for #{product.store_ids.join(',')}"
      if product.errors.messages[:permalink]
        product.permalink = @legacy_selector + '-' + @name.parameterize
        puts "(p2.1) ------------------------------------ Problem (#{product.errors.messages}) Saving product #{product.name} - #{product.properties.join(',')} for #{product.store_ids.join(',')}" if !product.save
      end
    end

    if(@reward_type == 'wholesale' || @reward_type == 'global')
      product.shipping_category = Spree::ShippingCategory.find_by_name('Mailed')
    else
      # TODO something different for Charities?
      product.shipping_category = Spree::ShippingCategory.find_by_name('In Classroom')
    end

    if @reward_type == 'wholesale'
      product.master.price = @retail_price * @retail_quantity
      product.set_property('retail_price',@retail_price)
      product.set_property('retail_quantity',@retail_quantity)
    end
    product.set_property("reward_type", @reward_type)
    product.set_property("legacy_selector", @legacy_selector)
    puts "(p3) ------------------------------------ Problem (#{product.errors.messages}) Saving product #{product.name} - #{product.properties.join(',')} for #{product.store_ids.join(',')}" if !product.save
    image_url = 'http://learningearnings.com/' + @image
    begin
      new_image = open('http://learningearnings.com/' + @image)
      if(new_image.base_uri.nil?) # couldn't fetch image
        new_image = open('app/assets/images/le_logo.png')
        puts ">>>>>using logo image since image could not be found<<<<<"
      else
        def new_image.original_filename; base_uri.path.split('/').last; end
      end
    rescue
      new_image = open('app/assets/images/le_logo.png')
    end
    new_spree_image = spree_image_class.new({:viewable_id => product.master.id,
                                              :viewable_type => 'Spree::Variant',
                                              :alt => "position 1",
                                              :position => 1})
    new_spree_image.attachment = new_image if new_image
    new_spree_image.save
    product.master.images << new_spree_image
    puts "(p2) ------------------------------------ Problem (#{product.errors.messages}) Saving product #{product.name} - #{product.properties.join(',')} for #{product.store_ids.join(',')}"  if !product.save
    if @reward_type == 'wholesale' && @school
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
