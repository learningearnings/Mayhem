class Spree::Admin::RewardsController < Spree::Admin::BaseController
  before_filter :authenticate_leadmin

  def index
    # insert code here to gather all products for the current school
    @products = Spree::Product.not_deleted.order(:name)
  end

  def new
    # create new spree product with specific options for LE Admin to use
    # TODO incorporate the school into the new object
    @product = Spree::Product.new
  end

  def create
    # create the product reward
    @product = Spree::Product.new
    @image = @product.master.images.new
    form_data
    if @product.save
      flash[:notice] = "Your reward was created successfully."
      redirect_to admin_rewards_path
    else
      flash[:error] = "There was an error saving your Reward, please check the form and try again"
      render 'new'
    end
  end

  def edit
    @product = Spree::Product.find(params[:id])
  end

  def update
    @product = Spree::Product.find(params[:id])
    form_data
    if @product.save
      flash[:notice] = "Your reward was updated successfully."
      redirect_to admin_rewards_path
    else
      flash[:error] = "There was an error updating your Reward, please check the form and try again"
      render 'edit'
    end
  end

  def form_data
    @product.name = params[:product][:name]
    @product.description = params[:product][:description]
    @product.price = params[:product][:price]
    @product.on_hand = params[:product][:on_hand]
    @product.available_on = params[:product][:available_on]
    @product.store_ids = params[:product][:store_ids]
    if params[:product][:images]
      i = @product.master.images.first
      i.attachment_file_name = params[:product][:images][:attachment_file_name].original_filename
      i.attachment_content_type = params[:product][:images][:attachment_file_name].content_type
      i.attachment = params[:product][:images][:attachment_file_name].tempfile
      i.save
    end
#   anything else?
  end

  def destroy
    @product = Spree::Product.find(params[:product])
    @product.deleted_at = Time.now
    if @product.save
      flash[:notice] = "Your reward was deleted successfully."
    else
      flash[:error] = "There was an error updating your Reward, please check the form and try again"
    end
    redirect_to admin_rewards_path
  end

  private

  def authenticate_leadmin
    if current_user && current_user.person.type == "LeAdmin"
      return true
    else
      flash[:error] = "You are not allowed to view this page."
      redirect_to root_path
    end
  end

end
