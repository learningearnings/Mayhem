require_relative '../models/active_model_command'

class CreateStoreProduct < ActiveModelCommand

  validates_presence_of :name, :store_id, :quantity, :retail_price, :available_on, :image
  validates :quantity, :numericality => {:greater_than_or_equal_to => 0}
  validates :retail_price, :numericality => {:greater_than_or_equal_to => 0}

  attr_accessor :name, :store_id, :quantity, :retail_price, :available_on, :image

  def initialize params={}
    @name             = params[:name]
    @description      = params[:description]
    @store_code       = params[:store_code]
    @quantity         = params[:quantity]
    @retail_price     = params[:retail_price]
    @available_on     = params[:available_on]
    @image            = params[:image]
  end

  def spree_image_class
    Spree::Image
  end

  def execute!
    product = Spree::Product.new
    product.name = @store_id
    product.store_ids = @
    product.available_on = @available_on
    product.quantity = 10000  #TODO - better quantity stuff
    new_image = open(@image)
    spree_image_class.create({:viewable_id => product.master.id,
                               :viewable_type => 'Spree::Variant',
                               :alt => "position 1",
                               :attachment => new_image,
                               :position => 1})
  end
end
