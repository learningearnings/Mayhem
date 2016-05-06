class Mobile::V1::Teachers::RewardsController < Mobile::V1::Teachers::BaseController
  def index
    @rewards = current_person.editable_rewards(current_school).order('name')
  end

  def show
    @reward = Spree::Product.find(params[:id])
  end

  def create
    logger.debug(params[:reward])
    @reward = Teachers::Reward.new(params[:reward])
    @reward.teacher = current_person
    @reward.school = current_school
    @reward.classrooms = Classroom.where(id: params[:reward][:classroom_id]) if params[:reward][:classroom_id]
    if @reward.save
      logger.debug(@reward.inspect)
      logger.debug("New reward id is: #{@reward.product.id}")
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new classrooms: @reward.classrooms, minimum_grade: "0", maximum_grade: "12"
      filter = filter_factory.find_or_create_filter(filter_condition)
      link = @reward.spree_product_filter_link || SpreeProductFilterLink.new(:product_id => @reward.id, :filter_id => filter.id)
      link.filter_id = filter.id
      @reward.spree_product_filter_link = link
      session[:filters] = filter_factory.find_filter_membership(current_user.person)      
      render json: { status: :ok, reward: @reward.product.id }
    else
      render json: { status: :unprocessible_entity }
    end
  end

  def update
    @reward = Spree::Product.find(params[:id])
    @reward.name = params[:reward][:name]
    @reward.description = params[:reward][:description]
    @reward.on_hand = params[:reward][:on_hand]
    @reward.price = params[:reward][:price]    
    if @reward.save
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new classrooms: [@reward.classrooms], minimum_grade: "0", maximum_grade: "12"
      filter = filter_factory.find_or_create_filter(filter_condition)
      link = @reward.spree_product_filter_link || SpreeProductFilterLink.new(:product_id => @reward.id, :filter_id => filter.id)
      link.filter_id = filter.id
      @reward.spree_product_filter_link = link
      session[:filters] = filter_factory.find_filter_membership(current_user.person)
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end
  
  def destroy
    @reward = Spree::Product.find(params[:id])
    @reward.destroy
    render json: { status: :ok }
  end
  
end
