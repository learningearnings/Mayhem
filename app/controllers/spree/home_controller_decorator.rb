Spree::HomeController.class_eval do
  before_filter :authenticate_user!

  def index
    @auction = ::Auction.new
    temp_params = params
    temp_params[:current_school] = current_school
    temp_params[:searcher_current_person] = current_person
    @searcher = Spree::Search::Filter.new(temp_params)
    @products = @searcher.retrieve_products
    if current_user.person.is_a?(SchoolAdmin) &&
        params[:current_store_id] &&
        le_store = Spree::Store.find_by_code('le')
      @products = @products.with_property_value('reward_type','wholesale') if params[:current_store_id] == le_store.id
    end


    # If they are a student we need all global products + products that are in their classroom
    if (current_person.is_a?(Student) && current_person.classrooms.present?) || current_person.is_a?(Teacher)
      @products = filter_rewards_by_classroom(@products)
    end

    @products = @products.order(:name).page(params[:page]).per(10)
    respond_with(@products)
  end
end
