Spree::HomeController.class_eval do

  def index
    params[:filters] = session[:filters]
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
#    respond_with(@products)
    respond_to do |format|
      format.html {render 'spree/products/index', :locals => {products: @products} }
    end
  end

end
