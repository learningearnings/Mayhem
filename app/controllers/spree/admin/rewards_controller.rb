class Spree::Admin::RewardsController < Spree::Admin::BaseController
  before_filter :authenticate_leadmin
  before_filter :maintain_page, :except => [:index]
  before_filter :check_saved_page, :only => [:index]
  before_filter :subdomain_required
  after_filter :only => [:index ] { |f| maintain_page(params[:page] || 1) }

  def index
    if Spree::Config.searcher_class != Spree::Search::Filter
      Spree::Config.searcher_class = Spree::Search::Filter
      $stderr.puts ("================================Had to reset the search filter class================================")
    end

    params[:searcher_current_user] = current_user
    params[:page] = nil unless params[:keywords].blank?
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products.order(:name).page(params[:page]).per(12)
    params[:searcher_current_user] = nil
#    maintain_page params[:page] || 1
  end

  def new
    # create new spree product with specific options for LE Admin to use
    # TODO incorporate the school into the new object
    @product = Spree::Product.new
    @product.available_on = Time.now
    @types = [["global","global"],["charity","charity"]]
    set_vars
  end

  def set_vars
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
    @classrooms = @current_school.classrooms
    @fulfillment_types = ["Shipped for School Inventory", "Shipped on Demand", "Digitally Delivered Coupon", "Digitally Delivered Content", "Digitally Delivered Game", "Digitally Delivered Charity Certificate", "School To Fulfill", "Auction Reward"]
    @purchased_by = ["LE", "Sponsor", "School", "Charity"]
    @categories = Spree::Taxonomy.where(name: "Categories").first.taxons
    @grades = ["K", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  end

  def create
    @product = Spree::Product.new
    #@image = @product.master.images.new # If we create an empty image, the master doesn't save correctly
    form_data
    if @product.save
      after_save
      flash[:notice] = "Your reward was created successfully."
      redirect_to admin_rewards_path, :page => (params[:page_id] || 0)
    else
      #set_vars
      #flash[:error] = "There was an error saving your Reward, please check the form and try again. " + @product.errors[:base].first
      flash[:error] = "There was an error saving your Reward, please check the form and try again."
      render 'new'
    end
  end

  def edit
    @product = Spree::Product.find(params[:id])
    if @product.has_property_type?
      @type = @product.property("reward_type")
      @types = [[@type, @type]]
      ["global", "charity"].each do |product_type|
        @types.push([product_type, product_type]) unless product_type == @type
      end
    else
      @types = [["global","global"],["charity","charity"]]
    end
    set_vars
  end

  def update
    @product = Spree::Product.find(params[:id])
    form_data
    if params[:product][:svg].present?
      @product.svg = params[:product][:svg][:svg_file_name]
    end
    if @product.save
      after_save
      flash[:notice] = "Your reward was updated successfully."
      redirect_to admin_rewards_path
    else
      flash[:error] = "There was an error updating your Reward, please check the form and try again"
      render 'edit'
    end
  end

  def form_data
    @product.name = params[:product][:name]
    @product.fulfillment_type = params[:product][:fulfillment_type]
    @product.purchased_by = params[:product][:purchased_by]
    @product.description = params[:product][:description]
    @product.price = params[:product][:price]
    @product.on_hand = params[:product][:on_hand]
    @product.available_on = params[:product][:available_on]
    @product.min_grade = params[:product][:min_grade]
    @product.max_grade = params[:product][:max_grade]
    @product.visible_to_all = params[:product][:visible_to_all]
    # set associated objects
    @product.taxons = params[:product][:taxons].map{|s| Spree::Taxon.find(s) if s.present? }.compact
    @product.states = params[:product][:states].map{|s| ::State.find(s) if s.present? }.compact
    @product.schools = params[:product][:schools].map{|s| School.find(s) if s.present? }.compact
  end

  def after_save
    @product.store_ids = store_ids_for(@product.fulfillment_type)
    @product.set_property("reward_type", product_type_for(@product))
    @product.save

    create_product_person_link unless @product.person
    handle_uploads
  end

  def handle_uploads
    if params[:product][:images].present?
      @product.images.first.destroy if @product.images.present?
      @product.images.create(params[:product][:images])
    end
  end

  def create_wholesale_properties
    # create retail price property
    retail_price_property = @product.properties.create name: "retail_price", presentation: "retail_price"
    price_product_property = retail_price_property.product_properties.first
    price_product_property.value = params[:retail_price]
    price_product_property.save
    # create retail qty property
    retail_qty_property = @product.properties.create(name: "retail_quantity", presentation: "retail_quantity")
    qty_product_property = retail_qty_property.product_properties.first
    qty_product_property.value = params[:retail_qty]
    qty_product_property.save
  end

  def destroy
    @product = Spree::Product.find(params[:id])
    @product.deleted_at = Time.now
    @product.audit_logs.create(district_guid: @product.schools.first.try(:district_guid), school_id: @product.schools.first.try(:id), school_sti_id: @product.schools.first.try(:sti_id), person_id: current_person.id, person_name: current_person.name, person_type: current_person.type, person_sti_id: current_person.sti_id, log_event_name: @product.name, action: "Deactivate")

    if @product.save
      flash[:notice] = "Your reward was deleted successfully #{view_context.link_to("Undo", admin_undelete_reward_path(:id => params[:id]))}".html_safe
    else
      flash[:error] = "There was an error updating your Reward, please check the form and try again"
    end
    redirect_to admin_rewards_path
  end

  def undelete
    @product = Spree::Product.find(params[:id])
    @product.deleted_at = nil
    if @product.save
      flash[:notice] = "Your reward was un-deleted successfully."
      flash[:undeleted] = params[:id]
    else
      flash[:error] = "There was an error updating your Reward, please check the form and try again"
    end
    redirect_to admin_rewards_path
  end

  private
  # Users are required to access the application
  # using a subdomain
  def subdomain_required
    return unless current_user
    return if !current_user.respond_to?(:person)
    return if current_user.person.is_a?(LeAdmin)
    if not_at_home && home_host
      token = Devise.friendly_token
      current_user.authentication_token = token
      my_redirect_url = home_host   + "/store/admin/rewards/?auth_token=#{token}"

      current_user.save
      sign_out(current_user)
      redirect_to my_redirect_url
    end
  end

  def home_subdomain
    "le"
  end

  def not_at_home
    return true if actual_subdomain.blank?
    first_subdomain = actual_subdomain
    return first_subdomain != home_subdomain
  end

  def actual_subdomain
    request.subdomain(1).split(".").first
  end
  helper_method :actual_subdomain

  def home_host
    HomeHostFinder.new.host_for(home_subdomain, request)
  end

  def check_saved_page
    return if params[:page]  # a passed in param trumps everything
    key = controller_path + '_page'
    if flash[key]
      params[:page] = flash[key]
    end
  end

  def maintain_page page = nil
    key = controller_path + '_page'
    last_page_key = controller_path + '_lastpage'
    if page.nil? && params[:page].nil?
      flash[key] = flash[last_page_key] # make it available for index if needed
      flash.keep(last_page_key) # keep the last page around in case there are other interactions
    elsif page
      flash[last_page_key] = page  # index keeps this hot for future reference by check_saved_page
    end
  end

  def authenticate_leadmin
    if current_user && current_user.person.type == "LeAdmin"
      return true
    else
      flash[:error] = "You are not allowed to view this page."
      redirect_to root_path
    end
  end

  def product_type_for(product)
    if @product.fulfillment_type == "Digitally Delivered Charity Certificate"
      "charity"
    else
      "global"
    end
  end

  def store_ids_for(fulfillment_type)
    if fulfillment_type == "Shipped for School Inventory"
      [Spree::Store.find_by_code('le').id]
    else
      Spree::Store.all.map{|s| s.id }
    end
  end

  def create_product_person_link
    SpreeProductPersonLink.create(product_id: @product.id, person_id: current_user.person_id)
  end
end
