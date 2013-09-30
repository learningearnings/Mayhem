# See doc/SpreeCheckoutFakery.md to see details on what's going on here.
Spree::OrdersController.class_eval do
  # Adds a new item to the order (creating a new order if none already exists)
  #
  # Parameters can be passed using the following possible parameter configurations:
  #
  # * Single variant/quantity pairing
  # +:variants => { variant_id => quantity }+
  #
  # * Multiple products at once
  # +:products => { product_id => variant_id, product_id => variant_id }, :quantity => quantity+
  # +:products => { product_id => variant_id, product_id => variant_id }, :quantity => { variant_id => quantity, variant_id => quantity }+
  
  def insufficient_quantity?
    variant_options = params[:variants].to_a.flatten
    variant  = Spree::Variant.find variant_options.first
    quantity = variant_options.last
    return true if quantity.to_i > variant.count_on_hand
  end

  def populate
    @order = current_order(true)
    if current_person.is_a?(Student)
      @order.empty!
    end
    if insufficient_quantity?
      flash[:error] = "Sorry, we don't have enough of that! Please try your order again."
      redirect_to :back and return
    end 
    @order.restock_items!
    params[:products].each do |product_id,variant_id|
      quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
      quantity = params[:quantity][variant_id].to_i if params[:quantity].is_a?(Hash)
      @order.add_variant(Spree::Variant.find(variant_id), quantity) if quantity > 0
    end if params[:products]

    params[:variants].each do |variant_id, quantity|
      quantity = quantity.to_i
      @order.add_variant(Spree::Variant.find(variant_id), quantity) if quantity > 0
    end if params[:variants]
    @order.unstock_items!

    fire_event('spree.cart.add')
    fire_event('spree.order.contents_changed')

    # --- The above code is spree core copied ---
    # --- Start our customization ---

    if @order.store == Spree::Store.find_by_code('le') && current_person.is_a?(SchoolAdmin)
      respond_with(@order) { |format| format.html { redirect_to main_app.restock_path } }
    else
      if @order.total > current_person.checking_account.balance
        flash[:notice] = t(:not_enough_credits_to_purchase)
        product = @order.line_items.first.product
        @order.empty!
        redirect_to product and return
      else
        OneClickSpreeProductPurchaseCommand.new(@order, current_person, current_school, params[:deliverer_id]).execute!
        flash[:notice] = "Purchase Completed."
        redirect_to "/"
      end
    end
  end


  def update
    @order = current_order
    @order.restock_items!
    if @order.update_attributes(params[:order])
      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      flash[:notice] = "Restock order updated"
    else
      flash[:notice] = "Restock NOT order updated"
    end
    @order.unstock_items!
    respond_with(@order) { |format| format.html { redirect_to main_app.restock_path } }
  end


  def new
    @order = Order.create
    respond_with(@order) { |format| format.html { redirect_to main_app.restock_path } }
  end

  def empty
    if @order = current_order
      @order.restock_items!
      @order.empty!
    end
    redirect_to spree.cart_path
  end


  def after_save_new_order
    @current_order.special_instructions = {school_id: current_school.id}.to_yaml
    @person = current_person
    @school = current_school
    add = Spree::Address.where(:company => @school.name)
      .where(:firstname => @person.first_name)
      .where(:lastname => @person.last_name)
      .where(:address1 => @school.address1)
      .where(:city => @school.city).first
    if add
      @current_order.ship_address = add
      @current_order.bill_address = add
    else
      shipping_address = {}
      shipping_address[:firstname] = @person.first_name
      shipping_address[:lastname] = @person.last_name
      shipping_address[:company] = @school.name
      shipping_address[:address1] = @school.address1
      shipping_address[:address2] = @school.address2
      shipping_address[:city] = @school.city
      shipping_address[:state_name] = @school.state.name
      shipping_address[:zipcode] = @school.zip
      shipping_address[:phone] = @school.school_phone
      shipping_address[:country] = Spree::Country.find_by_iso "US"
      @current_order.ship_address_attributes = shipping_address
      @current_order.bill_address_attributes = shipping_address
    end
  end


  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end
end
