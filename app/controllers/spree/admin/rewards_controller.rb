class Spree::Admin::RewardsController < Spree::Admin::BaseController
  before_filter :authenticate_leadmin

  def index
    @products = Spree::Product.not_deleted.with_property("reward_type").where("#{Spree::ProductProperty.table_name}.value" => ['charity','wholesale','global']).order(:name).page(params[:page]).per(10)
  end

  def new
    # create new spree product with specific options for LE Admin to use
    # TODO incorporate the school into the new object
    @product = Spree::Product.new
    @product.available_on = Time.now
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
      @type = @product.property("reward_type")
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

  def form_data
    @product.name = params[:product][:name]
    @product.description = params[:product][:description]
    @product.price = params[:product][:price]
    @product.on_hand = params[:product][:on_hand]
    @product.available_on = params[:product][:available_on]

    if params[:product_type] == "wholesale"
      @product.store_ids = ["#{Spree::Store.find_by_name("le").id}"]
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new :person_classes => ['LeAdmin', 'SchoolAdmin']
      @filter = filter_factory.find_or_create_filter(filter_condition)
      @product.set_property("retail_price",params[:retail_price])
      @product.set_property("retail_quantity",params[:retail_quantity])
    else
      # TODO insert code here to handle removing wholesale properties if type of product is changed during update
      @product.remove_property "retail_price"
      @product.remove_property "retail_quantity"
      @product.remove_property "master_product"

      store_id_array = []
      Spree::Store.all.each do |store|
        store_id_array.push(store.id) unless store.name == "le"
      end
      @product.store_ids = store_id_array
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

#    filter_factory = FilterFactory.new
#    filter_condition = FilterConditions.new classrooms: [Classroom.find(params[:classroom])], minimum_grade: params[:min_grade], maximum_grade: params[:max_grade]
#    filter = filter_factory.find_or_create_filter(filter_condition)
#    filter.save
#    @product.filter = filter

  end

  def after_save
    if @product.has_property_type?
      property = @product.properties.select{|p| p.name == "type"}.first
      property.presentation = params[:product_type]
      property.save
    else
      @product.set_property("reward_type", params[:product_type])
    end
    create_wholesale_properties if @product.requires_wholesale_properties?
    SpreeProductPersonLink.create(product_id: @product.id, person_id: current_user.person_id) unless @product.person
  end

  def create_wholesale_properties
    # create retail price property
    retail_price_property = @product.properties.create name: "retail_price", presentation: "retail_price"
    price_product_property = retail_price_property.product_properties.first
    price_product_property.value = params[:retail_price]
    price_product_property.save
    # create retail qty property
    retail_qty_property = @product.properties.create(name: "retail_quantity", presentation: "retail_quantity")
    qty_product_property = retail_qty_property.product_properties.first
    qty_product_property.value = params[:retail_qty]
    qty_product_property.save
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
