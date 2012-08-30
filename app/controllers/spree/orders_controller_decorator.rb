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
    if current_person.type == "SchoolAdmin"
      payment_source_attributes["number"] = current_person.main_account(current_person.schools.first).name
    else
      payment_source_attributes["number"] = current_person.checking_account_name
    end
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

    # Go ahead and find or create the wholesale product in the SchoolAdmin's school store
    if @order.store == Spree::Store.find_by_name("le")
      create_school_products
    end

    flash[:notice] = "Bought that stuff..."
    redirect_to "/"
  end

  def create_school_products
    if current_person.class.name == "SchoolAdmin"
      wholesale_product = @order.products.first
      retail_price = wholesale_product.product_properties.select{|s| s.property.name == "retail_price" }.first.value
      retail_qty = wholesale_product.product_properties.select{|s| s.property.name == "retail_quantity" }.first.value

      if Spree::Product.all.select{|s| s.name == wholesale_product.name && s.store_ids.include?(current_person.schools.first.id) }.present?
        retail_product = Spree::Product.all.select{|s| s.name == wholesale_product.name && s.store_ids.include?(current_person.schools.first.id) }.first
        retail_product.count_on_hand += retail_qty
        retail_product.save
      else
        retail_product = wholesale_product.duplicate
        retail_product.name = wholesale_product.name # need to set this to avoid "COPY OF ..."
        retail_product.price = retail_price
        retail_product.description = wholesale_product.description
        retail_product.available_on = Time.now
        retail_product.deleted_at = nil
        retail_product.permalink = ""
        retail_product.meta_description = ""
        retail_product.meta_keywords = ""
        retail_product.tax_category_id = nil
        retail_product.count_on_hand = retail_qty
        retail_product.store_ids = [current_person.schools.first.id]
        retail_product.save!
      end
    else
      flash[:alert] = "You are not allowed to purchase products from the Learning Earnings store! Please visit your school store to purchase items."
    end
  end

  private
  def current_person
    current_user.person
  end
end
