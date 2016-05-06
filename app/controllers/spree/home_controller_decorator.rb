Spree::HomeController.class_eval do
  before_filter :authenticate_user!

  def index
    @auction = ::Auction.new
    temp_params = params
    temp_params[:current_school] = current_school
    temp_params[:searcher_current_person] = current_person
    @searcher = Spree::Search::Filter.new(temp_params)
    Rails.logger.debug("AKT Searcher: #{ @searcher.inspect }")    
    @products = @searcher.retrieve_products
    Rails.logger.debug("AKT My Product: #{@products.select{ | prod | prod.id == 18916}}")
    # If they are a student we need all global products + products that are in their classroom
    Rails.logger.debug("AKT2 Spree Home Controller: #{@searcher.inspect}")
    if current_person.is_a?(Student)
      Rails.logger.debug("AKT2 filter_rewards_by_classroom")
      #@products = filter_rewards_by_classroom(@products)
    end
    
    @teachers = @products.includes(:person).map(&:person).compact.uniq
    @products = filter_by_rewards_for_teacher(@products, params[:teacher], params[:reward_type])
    @products = @products.order("spree_products.name").page(params[:page]).per(9)
    MixPanelTrackerWorker.perform_async(current_user.id, 'View School Store', mixpanel_options)
    respond_with(@products)
  end
end
