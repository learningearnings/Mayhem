require_relative '../models/active_model_command'

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
    @image            = params[:image]
    @filter           = params[:filter]
  end

  def spree_image_class
    Spree::Image
  end

  def spree_store_class
    Spree::Store
  end


  def execute!
    store = spree_store_class.find_by_code(@school.store_subdomain)
    return if store.nil?
    product = Spree::Product.new
    product.name = @name
    product.description = @description
    product.permalink = @name.parameterize
    product.price = @retail_price
    product.store_ids = store.id
    product.available_on = @available_on
    product.count_on_hand = 100  #TODO - better quantity stuff
    new_image = open('http://learningearnings.com/images/rewardimage/' + @image)
    new_spree_image = spree_image_class.create({:viewable_id => product.master.id,
                                                 :viewable_type => 'Spree::Variant',
                                                 :alt => "position 1",
                                                 :attachment => new_image,
                                                 :position => 1})
    new_spree_image.attachment_file_name = @image
    product.master.images << new_spree_image

    if @filter.nil?
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new schools: [@school]
      @filter = filter_factory.find_or_create_filter(filter_condition)
    end
    link = product.spree_product_filter_link || SpreeProductFilterLink.new(:product_id => product.id, :filter_id => @filter.id)
    link.filter_id = @filter.id
    product.spree_product_filter_link = link

    product.save
    product
  end
end
