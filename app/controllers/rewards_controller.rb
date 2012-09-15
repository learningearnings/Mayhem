class RewardsController < ApplicationController

  def index
    @products = Spree::Product.not_deleted.order(:name)
  end

  def show
    @product = Spree::Product.find(params[:id])
  end

  def new
    # create new spree product with specific options for LE Admin to use
    # TODO incorporate the school into the new object
    @product = Spree::Product.new
  end

  def create
    # create the product reward
    @product = Spree::Product.new
    form_data
    redirect_to rewards_path
  end

  def edit
    @product = Spree::Product.find(params[:id])
  end

  def update
    @product = Spree::Product.find(params[:id])
    form_data
    redirect_to rewards_path
  end

  def form_data
    @product.name = params[:product][:name]
    @product.description = params[:product][:description]
    @product.price = params[:product][:price]
    @product.on_hand = params[:product][:on_hand]
    @product.available_on = params[:product][:available_on]
    @product.store_ids = params[:product][:store_ids]
#   anything else?
    @product.save
  end

  def destroy
    @product = Spree::Product.find(params[:product])
    @product.deleted_at = Time.now
    @product.save
    redirect_to rewards_path
  end

end
