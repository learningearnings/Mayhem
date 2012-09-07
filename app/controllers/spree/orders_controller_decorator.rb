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

    params[:products].each do |product_id,variant_id|
      quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
      quantity = params[:quantity][variant_id].to_i if params[:quantity].is_a?(Hash)
      @order.add_variant(Spree::Variant.find(variant_id), quantity) if quantity > 0
    end if params[:products]

    params[:variants].each do |variant_id, quantity|
      quantity = quantity.to_i
      @order.add_variant(Spree::Variant.find(variant_id), quantity) if quantity > 0
    end if params[:variants]

    fire_event('spree.cart.add')
    fire_event('spree.order.contents_changed')

    OneClickSpreeProductPurchaseCommand.new(@order, current_person, current_school).execute!
    
    flash[:notice] = "Bought that stuff..."
    redirect_to "/"
  end

  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end
end
