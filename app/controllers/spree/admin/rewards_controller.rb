class Spree::Admin::RewardsController < Spree::Admin::BaseController
  before_filter :authenticate_leadmin

  def index
    # insert code here to gather all products for the current school
    @products = Spree::Product.not_deleted.order(:name).select{|p| p.properties.select{|s| s.presentation == "charity" || s.presentation == "global" || s.presentation == "wholesale" }.present? }
  end

  def new
    # create new spree product with specific options for LE Admin to use
    # TODO incorporate the school into the new object
    @product = Spree::Product.new
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
    @types = [["wholesale","wholesale"],["global","global"],["charity","charity"]]
    @classrooms = @current_school.classrooms
  end

  def create
    # create the product reward
    @product = Spree::Product.new
    @image = @product.master.images.new
    form_data
    if @product.save
      after_save
      flash[:notice] = "Your reward was created successfully."
      redirect_to admin_rewards_path
    else
      flash[:error] = "There was an error saving your Reward, please check the form and try again"
      render 'new'
    end
  end

  def edit
    @product = Spree::Product.find(params[:id])
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
    @classrooms = @current_school.classrooms
    if @product.has_property_type?
      @type = @product.properties.select{|s| s.name == "type" }.first.presentation
      @types = [[@type, @type]]
      ["wholesale", "global", "charity"].each do |product_type|
        @types.push([product_type, product_type]) unless product_type == @type
      end
    else
      @types = [["wholesale","wholesale"],["global","global"],["charity","charity"]]
    end
  end

  def update
    @product = Spree::Product.find(params[:id])
    form_data
    if @product.save
      after_save
      flash[:notice] = "Your reward was updated successfully."
      redirect_to admin_rewards_path
    else
      flash[:error] = "There was an error updating your Reward, please check the form and try again"
      render 'edit'
    end
  end

  def after_save
    if @product.has_property_type?
      if @product.store_ids.include?(Spree::Store.find_by_name("le").id)
        unless @product.has_retail_properties?
          retail_price_property = @product.properties.create name: "retail_price", presentation: "retail_price"
          retail_qty_property = @product.properties.create(name: "retail_quantity", presentation: "retail_quantity")
          price_product_property.value = retail_price_property.product_properties.first
          price_product_property.value = params[:retail_price]
          price_product_property.save
          qty_product_property.value = retail_qty_property.product_properties.first
          qty_product_property.value = params[:retail_price]
          qty_product_property.save
        end
      end
      property = @product.properties.select{|p| p.name == "type"}.first
      property.presentation = params[:product_type]
      property.save
    else
      @product.properties.create(name: "type", presentation: params[:product_type])
    end
    SpreeProductPersonLink.create(product_id: @product.id, person_id: current_user.person_id) unless @product.person
  end

  def form_data
    @product.name = params[:product][:name]
    @product.description = params[:product][:description]
    @product.price = params[:product][:price]
    @product.on_hand = params[:product][:on_hand]
    @product.available_on = params[:product][:available_on]
    if params[:product][:store_ids].include?(Spree::Store.find_by_name("le").id.to_s)
      # then product must be a wholesale type to be sold in the LE store, remove other store ids.
      @product.store_ids = ["#{Spree::Store.find_by_name("le").id}"]
    else
      @product.store_ids = params[:product][:store_ids]
    end
    if params[:product][:images]
      i = @product.master.images.first
      i.attachment_file_name = params[:product][:images][:attachment_file_name].original_filename
      i.attachment_content_type = params[:product][:images][:attachment_file_name].content_type
      i.attachment = params[:product][:images][:attachment_file_name].tempfile
      i.save
    end
    if params[:product][:svg]
      i = @product
      i.svg_file_name = params[:product][:svg][:svg_file_name].original_filename
      i.svg = params[:product][:svg][:svg_file_name].tempfile
      i.save
    end
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
