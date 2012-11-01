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
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
    @types = [["wholesale","wholesale"],["global","global"],["charity","charity"]]
    @classrooms = @current_school.classrooms
  end

  def create
    # create the product reward
    @product = Spree::Product.new
    @image = @product.master.images.new
    form_data
    if @product.save
      after_save
      flash[:notice] = "Your reward was created successfully."
      redirect_to admin_rewards_path, :page => (params[:page_id] || 0)
    else
      flash[:error] = "There was an error saving your Reward, please check the form and try again"
      render 'new'
    end
  end

  def edit
    @product = Spree::Product.find(params[:id])
    @current_school = School.find(session[:current_school_id])
    @grades = @current_school.grades
    @classrooms = @current_school.classrooms
    if @product.has_property_type?
      @type = @product.property("reward_type")
      @types = [[@type, @type]]
      ["wholesale", "global", "charity"].each do |product_type|
        @types.push([product_type, product_type]) unless product_type == @type
      end
    else
      @types = [["wholesale","wholesale"],["global","global"],["charity","charity"]]
    end
  end

  def update
    @product = Spree::Product.find(params[:id])
    form_data
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
    @product.description = params[:product][:description]
    @product.price = params[:product][:price]
    @product.on_hand = params[:product][:on_hand]
    @product.available_on = params[:product][:available_on]

    if params[:product_type] == "wholesale"
      @product.store_ids = ["#{Spree::Store.find_by_name("le").id}"]
      filter_factory = FilterFactory.new
      filter_condition = FilterConditions.new :person_classes => ['LeAdmin', 'SchoolAdmin']
      @filter = filter_factory.find_or_create_filter(filter_condition)
      @product.set_property("retail_price",params[:product][:retail_price])
      @product.set_property("retail_quantity",params[:product][:retail_quantity])
      @product.set_property("wholesale_description",params[:wholesale_description])
    else
      # TODO insert code here to handle removing wholesale properties if type of product is changed during update
      @product.remove_property "retail_price"
      @product.remove_property "retail_quantity"
      @product.remove_property "master_product"

      store_id_array = []
      Spree::Store.all.each do |store|
        store_id_array.push(store.id)
      end
      @product.set_property "reward_type", params[:product_type]
      @product.store_ids = store_id_array
    end

    if params[:product][:images]
      i = @product.master.images.first
      i.attachment_file_name = params[:product][:images][:attachment_file_name].original_filename
      i.attachment_content_type = params[:product][:images][:attachment_file_name].content_type
      i.attachment = params[:product][:images][:attachment_file_name].tempfile
      i.save
    end
    if params[:product][:svg]
      i = @product
      i.svg_file_name = params[:product][:svg][:svg_file_name].original_filename
      i.svg = params[:product][:svg][:svg_file_name].tempfile
      i.save
    end

#    filter_factory = FilterFactory.new
#    filter_condition = FilterConditions.new classrooms: [Classroom.find(params[:classroom])], minimum_grade: params[:min_grade], maximum_grade: params[:max_grade]
#    filter = filter_factory.find_or_create_filter(filter_condition)
#    filter.save
#    @product.filter = filter

  end

  def after_save
    @product.set_property("reward_type", params[:product_type])
    create_wholesale_properties if @product.requires_wholesale_properties?
    SpreeProductPersonLink.create(product_id: @product.id, person_id: current_user.person_id) unless @product.person
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
    return if current_user && !current_user.respond_to?(:person)
    if current_user && (request.subdomain.empty? || request.subdomain != home_subdomain && 
                        (!(current_user.person.is_a?(SchoolAdmin) && [home_subdomain, 'le'].include?(request.subdomain)))
                        ) && home_host
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

  def home_host
    return request.protocol + request.host_with_port unless current_user.person
    if current_user && current_user.person
      # TODO - figure out a better hostname naming scheme
      subdomain = home_subdomain
      if request.host.match /^#{subdomain}\./
        host = request.protocol + request.host_with_port
      else
        if !request.subdomain.empty?
          host = request.host.gsub /^#{request.subdomain}\./,''
        else
          host = request.host
        end
        subdomain = subdomain + '.' + host

        # If this is a development environment, check to see if the
        # hosts file is setup right

        if Rails.env == 'development'
          match_found = false
          begin
            subdomain_address = Addrinfo.getaddrinfo(subdomain,request.port)
          rescue
            subdomain_address = nil
          end
          original_address =  Addrinfo.getaddrinfo(request.host,request.port)
          if subdomain_address
            subdomain_address.each do |sa|
              original_address.each do |oa|
                if sa.ip_address == oa.ip_address
                  match_found = true
                  break
                end
              end
            end
          end
          if !match_found
            flash[:error] = ("Localhost(s) aren't configured correctly for development - use " + "<a href=\"http://lvh.me:3000\">lvh.me:3000</a>").html_safe
            return nil
          end
        end
        host = request.protocol + subdomain
        if request.port && request.port != 80
          host = host +':' + request.port.to_s
        end
      end
    else
      request.protocol + request.host_with_port
    end
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

end
