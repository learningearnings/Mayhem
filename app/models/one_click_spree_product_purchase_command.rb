class OneClickSpreeProductPurchaseCommand
  def initialize(order, person, school, deliverer_id)
    @order  = order
    @person = person
    @school = school
    @deliverer_id = deliverer_id
  end

  def execute!
    skip_irrelevant_spree_order_steps
    Rails.logger.info("AKT OneClickSpreeProductPurchaseCommand: #{@school.inspect}")
    purchase
 
    if can_create_school_products?
      create_school_products
    else
      queue_delivery(@order.line_items)
    end

    if @order.products.first && @order.products.first.fulfillment_type != 'Shipped on Demand'
      mark_as_shipped
    end
  end

  protected
  # Find or create the wholesale product in the SchoolAdmin's school store
  def create_school_products
    retail_store = Spree::Store.find_by_code(@school.store_account_name)

    @order.products.each do |wholesale_product|
      retail_price = wholesale_product.property("retail_price") || 100000
      retail_qty = wholesale_product.property("retail_quantity") || 0

      SchoolStoreProductDistributionCommand.new(:master_product => wholesale_product,
                                                :school => @school,
                                                :quantity => retail_qty,
                                                :person => @person,
                                                :retail_price => retail_price).execute!
    end
  end

  # Create a RewardDelivery from the teacher to the purchasing student for these
  # products
  def queue_delivery(line_items)
    Rails.logger.info("AKT: queue_delivery #{line_items.inspect}")
    line_items.each do |line_item|
      RewardDelivery.create(from_id: @deliverer_id, to_id: @person.id, reward_id: line_item.id)
    end
  end

  def can_create_school_products?
    @order.store == Spree::Store.find_by_name("le") && @person.is_a?(SchoolAdmin)
  end

  def skip_irrelevant_spree_order_steps
    # Address
    @deliverer = Teacher.find_by_id(@deliverer_id)
    @deliverer = @person unless @deliverer
    addr = Spree::Address.where(:firstname => @deliverer.name)
      .where(:lastname => @person.name)
      .where(:company => @school.name)
      .where(:address1 => @school.address1)
      .where(:city => @school.city).first
    if addr
      @order.ship_address = addr
      @order.bill_address = addr
    else
      shipping_address = {}
      shipping_address[:company] = @school.name
      shipping_address[:firstname] = @deliverer.name
      shipping_address[:lastname] = @person.name
      shipping_address[:address1] = @school.address1
      shipping_address[:address2] = @school.address2
      shipping_address[:city] = @school.city
      shipping_address[:state_name] = @school.state.name
      shipping_address[:zipcode] = @school.zip
      shipping_address[:phone] = @school.school_phone.blank? ? "1111111111" : @school.school_phone
      shipping_address[:country] = Spree::Country.find_by_iso "US"
      @order.ship_address_attributes = shipping_address
      @order.bill_address_attributes = shipping_address
    end

    # Delivery
    if @order.line_items.first && @order.line_items.first.product.shipping_category && (@order.line_items.first.product.shipping_category.shipping_methods.count > 0)
      @order.shipping_method_id = @order.line_items.first.product.shipping_category.shipping_methods.first.id
    else
      @order.shipping_method = Spree::ShippingCategory.find_by_name('In Classroom').shipping_methods.first
    end
  end

  def mark_as_shipped
    @order.create_shipment!
    @shipment = @order.shipment
#    @order.restock_items!  #shipment below will pull them out again
    @order.save
    while @order.state != 'shipped'
      current_status = @order.state
      @order.save
      @order.next
      break if @order.state == current_status
    end
    @shipment.ready
    @shipment.reload
    @shipment.ship
    @shipment.save
    @order.save
  end

  def purchase
    # Payment
    @order.restock_items!   #shipping will pull them out again
    payment_source_attributes = {}
    payment_source_attributes["number"] = @person.checking_account_name

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
    while @order.state != 'transmitted'
      current_status = @order.state
      @order.save
      @order.next
      break if @order.state == current_status
    end
    @order.save
  end
end
