class OneClickSpreeProductPurchaseCommand
  def initialize(order, person, school, deliverer_id)
    @order  = order
    @person = person
    @school = school
    @deliverer_id = deliverer_id
  end

  def execute!
    skip_irrelevant_spree_order_steps
    purchase

    if can_create_school_products?
      create_school_products
    else
      queue_delivery(@order.products)
    end
  end

  protected
  # Find or create the wholesale product in the SchoolAdmin's school store
  def create_school_products
    retail_store = Spree::Store.find_by_code(@school.store_account_name)

    @order.products.each do |wholesale_product|
      retail_price = wholesale_product.product_properties.select{|s| s.property.name == "retail_price" }.first.value
      retail_qty = wholesale_product.product_properties.select{|s| s.property.name == "retail_quantity" }.first.value

      SchoolStoreProductDistributionCommand.new(:master_product => wholesale_product,
                                                :school => @school,
                                                :quantity => retail_qty,
                                                :person => @person,
                                                :retail_price => retail_price).execute!
    end
  end

  # Create a RewardDelivery from the teacher to the purchasing student for these
  # products
  def queue_delivery(products)
    products.each do |product|
      RewardDelivery.create(from_id: @deliverer_id, to_id: @person.id, reward_id: product.id)
    end
  end

  def can_create_school_products?
    @order.store == Spree::Store.find_by_name("le") && @person.is_a?(SchoolAdmin)
  end

  def skip_irrelevant_spree_order_steps
    @order.next

    # Address
    shipping_address = {}
    shipping_address[:firstname] = @person.first_name
    shipping_address[:lastname] = @person.last_name
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

  end

  def purchase
    # Payment
    payment_source_attributes = {}
    if @person.is_a? SchoolAdmin
      payment_source_attributes["number"] = @school.store_account_name
    else
      payment_source_attributes["number"] = @person.checking_account_name
    end
    payment_source_attributes["month"] = "1"
    payment_source_attributes["year"] = "2100"
    payment_source_attributes["verification_value"] = "111"
    payment_source_attributes["first_name"] = @person.first_name
    payment_source_attributes["last_name"] = @person.last_name

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
  end
end
