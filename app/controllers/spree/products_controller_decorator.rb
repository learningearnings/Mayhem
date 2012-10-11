Spree::ProductsController.class_eval do
  before_filter :authenticate_user!

  def index
    params[:filters] = session[:filters]
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
    respond_with(@products)
  end

end
