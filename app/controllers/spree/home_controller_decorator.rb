Spree::HomeController.class_eval do

  def index
    params[:filters] = session[:filters]
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
    respond_with(@products)
  end

end
