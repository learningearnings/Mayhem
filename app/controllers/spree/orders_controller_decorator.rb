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
  def populate
    @order = current_order(true)
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
      OneClickSpreeProductPurchaseCommand.new(@order, current_person, current_school, params[:deliverer_id]).execute!
      flash[:notice] = "Bought that stuff..."
      redirect_to "/"
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
  end


  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end
end
