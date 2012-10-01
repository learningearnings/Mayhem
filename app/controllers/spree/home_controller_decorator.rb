Spree::HomeController.class_eval do

  def index
    with_filters_params = params
    with_filters_params[:filters] = session[:filters]
    @searcher = Spree::Config.searcher_class.new(with_filters_params)
    @products = @searcher.retrieve_products
    respond_with(@products)
  end

end
