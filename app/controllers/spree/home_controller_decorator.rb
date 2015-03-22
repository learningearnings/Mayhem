Spree::HomeController.class_eval do
  before_filter :authenticate_user!

  def index
    @auction = ::Auction.new
    temp_params = params
    temp_params[:current_school] = current_school
    temp_params[:searcher_current_person] = current_person
    @searcher = Spree::Search::Filter.new(temp_params)
    @products = @searcher.retrieve_products

    # If they are a student we need all global products + products that are in their classroom
    if current_person.is_a?(Student)
      @products = filter_rewards_by_classroom(@products)
    end

    @products = @products.order(:name).page(params[:page]).per(9)
    MixPanelWorker.new.track(current_user.id, 'View School Store')
    respond_with(@products)
  end
end
