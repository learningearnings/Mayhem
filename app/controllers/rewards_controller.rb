class RewardsController < ApplicationController
  before_filter :authenticate_teacher
  before_filter :foo

  def foo
  end

  def index
    with_filters_params = params
    with_filters_params[:filters] = session[:filters] || [1]
    @searcher = Spree::Config.searcher_class.new(with_filters_params)
    @products = @searcher.retrieve_products
    respond_with(@products)
#    @products = Spree::Product.not_deleted.order(:name)
  end

  def show
    @product = Spree::Product.find(params[:id])
  end

  def new
    # create new spree product with specific options for LE Admin to use
    # TODO incorporate the school into the new object
    @product = Spree::Product.new
    @grades = [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],[8,8],[9,9],[10,10],[11,11],[12,12]]
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
  end

  def create
    # create the product reward
    @product = Spree::Product.new
    @image = @product.master.images.new
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
    form_data
    if @product.save
      flash[:notice] = "Your reward was created successfully."
      redirect_to rewards_path
    else
      flash[:error] = "There was an error saving your Reward, please check the form and try again"
      render 'new'
    end
  end

  def edit
    @product = Spree::Product.find(params[:id])
    @grades = [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],[8,8],[9,9],[10,10],[11,11],[12,12]]
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
  end

  def update
    @product = Spree::Product.find(params[:id])
    form_data
    if @product.save
      flash[:notice] = "Your reward was updated successfully."
      redirect_to rewards_path
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

    filter_factory = FilterFactory.new
    filter_condition = FilterConditions.new classrooms: [Classroom.find(params[:classroom])], minimum_grade: params[:min_grade], maximum_grade: params[:max_grade]
    filter = filter_factory.find_or_create_filter(filter_condition)
    link = @product.spree_product_filter_link || SpreeProductFilterLink.new(:product_id => @product.id, :filter_id => filter.id)
    link.filter_id = filter.id
    @product.spree_product_filter_link = link
    session[:filters] = filter_factory.find_filter_membership(current_user.person)
#    p = SpreeProductFilterLink.new product_id: @product.id, filter_id: f.id
#    p.save
#    @product.filter = f.id
    #  anything else?
  end

  def destroy
    @product = Spree::Product.find(params[:product])
    @product.deleted_at = Time.now
    if @product.save
      flash[:notice] = "Your reward was deleted successfully."
    else
      flash[:error] = "There was an error updating your Reward, please check the form and try again"
    end
    redirect_to rewards_path
  end

  private

  def authenticate_teacher
    if current_user && current_user.person.type == "Teacher"
      return true
    else
      flash[:error] = "You are not allowed to view this page."
      redirect_to root_path
    end
  end

end
