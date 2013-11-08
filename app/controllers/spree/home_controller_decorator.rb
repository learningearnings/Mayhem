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
    if current_person.is_a?(Student) && current_person.classrooms.present?
      temp_params[:classrooms] = current_person.classrooms.pluck(:id)
      @products.reject! do |product|
        # Products that have no classrooms should not be rejected
        next unless product.classrooms.any?
        # If there is an intersection between the products classrooms and my classrooms, don't reject
        (product.classrooms.pluck(:id) & temp_params[:classrooms]).any? ? false : true
      end
      # To fix pagination we need an active record relation, not an array
      # Why are you laughing?
      @products = Spree::Product.where(:id => @products.map(&:id))
    end

    @products = @products.page(params[:page]).per(9)
    respond_with(@products)
  end
end
