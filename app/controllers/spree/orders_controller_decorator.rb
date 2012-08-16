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

    # --- The above code is spree core copied ---
    # --- Start our customization ---
    # Cart
    @order.next

    # Address
    shipping_address = {}
    shipping_address[:firstname] = current_person.first_name
    shipping_address[:lastname] = current_person.last_name
    shipping_address[:address1] = "6238 Canterbury Road"
    shipping_address[:city] = "Pinson"
    shipping_address[:state_name] = "Alabama"
    shipping_address[:zipcode] = "35126"
    shipping_address[:phone] = "2052153957"
    shipping_address[:country] = Spree::Country.find_by_iso "US"
    @order.ship_address_attributes = shipping_address
    @order.bill_address_attributes = shipping_address
    @order.save
    @order.next

    # Delivery
    @order.shipping_method_id = Spree::ShippingMethod.first.id
    @order.save
    @order.next
    
    # Payment
    payment_source_attributes = {}
    payment_source_attributes["number"] = current_person.checking_account_name
    payment_source_attributes["month"] = "1"
    payment_source_attributes["year"] = "2100"
    payment_source_attributes["verification_value"] = "111"
    payment_source_attributes["first_name"] = current_person.first_name
    payment_source_attributes["last_name"] = current_person.last_name

    payment_params = {
      amount: @order.amount,
      payment_method: Spree::PaymentMethod.where(environment: Rails.env).first,
      source_attributes: payment_source_attributes
    }
    payment = Spree::Payment.new(payment_params, without_protection: true)
    @order.payments = [payment]
    @order.save

    # Trigger the purchase
    @order.next

    flash[:notice] = "Bought that stuff..."
    redirect_to "/"
  end

  private
  def current_person
    current_user.person
  end
end
