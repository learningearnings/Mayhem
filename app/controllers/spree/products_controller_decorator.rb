Spree::ProductsController.class_eval do
  before_filter :authenticate_user!

  def index
    if params[:search]
      [:ascend_by_master_price].each do |field|
        if params[:search][field] && params[:search][field] == ''
          params[:search][field] = nil
        end
      end
    end
    temp_params = params
    temp_params[:filters] = session[:filters]
    temp_params[:current_school] = current_school
    if current_person.is_a?(Student) && current_person.classrooms.present?
      temp_params[:classrooms] = current_person.classrooms.map(&:id)
    end
    #Rails.logger.debug "AKT Filters: #{session[:filters].inspect}"
    @searcher = Spree::Search::Filter.new(temp_params)
    @products = @searcher.retrieve_products
    if current_user.person.is_a?(SchoolAdmin) && params[:current_store_id]
      le_store = Spree::Store.find_by_code('le')
      @products = @products.with_property_value('reward_type','wholesale') if params[:current_store_id] == le_store.id
    end
    @products = @products.page(params[:page]).per(9)
    respond_with(@products)
  end
  
  def show
    render :layout => "application"
  end
end

