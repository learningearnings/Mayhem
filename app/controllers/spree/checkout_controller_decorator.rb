Spree::CheckoutController.class_eval do
  before_filter :we_dont_ever_checkout


  def before_payment
    payment_source_attributes = {}
    if current_person.is_a? SchoolAdmin
      payment_source_attributes["number"] = current_school.store_account_name
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
    @order.next
    shipment = @order.shipment
    shipment.ready
    current_order.payments.destroy_all if request.put?
  end

#  def before_delivery
#    return if params[:order].present?
#    @order.shipping_method ||= (@order.rate_hash.first && @order.rate_hash.first[:shipping_method])
#  end


  def state_callback(before_or_after = :before)
    method_name = :"#{before_or_after}_#{@order.state}"
        send(method_name) if respond_to?(method_name, true)
  end


  def xx_before_address
    @order.next
    @person = current_person
    @school = current_school
    # Address

    shipping_address = {}
    shipping_address[:firstname] = @person.first_name
    shipping_address[:lastname] = @person.last_name
    shipping_address[:company] = @school.name
    shipping_address[:address1] = @school.addresses.first.line1
    shipping_address[:address2] = @school.addresses.first.line2
    shipping_address[:city] = @school.addresses.first.city
    shipping_address[:state_name] = @school.addresses.first.state.name
    shipping_address[:zipcode] = @school.addresses.first.zip
    shipping_address[:phone] = @school.school_phone
    shipping_address[:country] = Spree::Country.find_by_iso "US"
    @order.ship_address_attributes = shipping_address
    @order.bill_address_attributes = shipping_address
    @order.save
    @order.shipping_method_id = @order.line_items.first.product.shipping_category.shipping_methods.first
#    @order.next
    @order.save
#    @order.next
    payment_source_attributes = {}
    payment_source_attributes["number"] = @school.store_account_name

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
    @order.save
    @order.next
    redirect_to main_app.restock_url
  end

  def we_dont_ever_checkout
    flash[:notice] = t('transmit_notice')
    redirect_to main_app.restock_path
  end

  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end

end
