Spree::ProductsController.class_eval do
  before_filter :authenticate_user!

  def index
    temp_params = params
    temp_params[:filters] = session[:filters]
    temp_params[:current_school] = current_school
    if current_person.is_a?(Student) && current_person.classrooms.present?
      temp_params[:classrooms] = current_person.classrooms.map(&:id)
    end
    @searcher = Spree::Search::Filter.new(temp_params)
    logger.debug("AKT show filters")
    logger.debug(@searcher.inspect)
    @products = @searcher.retrieve_products
    logger.debug(@products.inspect)
    logger.debug("AKT END fetch products")
    if current_user.person.is_a?(SchoolAdmin) && params[:current_store_id]
      le_store = Spree::Store.find_by_code('le')
      @products = @products.with_property_value('reward_type','wholesale') if params[:current_store_id] == le_store.id
    end
    @products = @products.page(params[:page]).per(9)
    respond_with(@products)
  end
  
  def show
    MixPanelTrackerWorker.perform_async(current_user.id, 'View Reward Item', mixpanel_options)
  end
end

