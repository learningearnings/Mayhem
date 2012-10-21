Spree::HomeController.class_eval do

  def index
    temp_params = params
    temp_params[:filters] = session[:filters]
    @searcher = Spree::Config.searcher_class.new(temp_params)
    @products = @searcher.retrieve_products
    if current_user.person.is_a?(SchoolAdmin) &&
        params[:current_store_id] &&
        le_store = Spree::Store.find_by_code('le')
      @products = @products.with_property_value('reward_type','wholesale') if params[:current_store_id] == le_store.id
    end
    @products = @products.page(params[:page]).per(9)
    respond_with(@products)
  end

end
