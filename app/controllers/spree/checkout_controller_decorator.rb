Spree::CheckoutController.class_eval do
  def before_payment
    binding.pry
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

  def before_delivery
    return if params[:order].present?
    @order.shipping_method ||= (@order.rate_hash.first && @order.rate_hash.first[:shipping_method])
  end


  def state_callback(before_or_after = :before)
    binding.pry
    method_name = :"#{before_or_after}_#{@order.state}"
        send(method_name) if respond_to?(method_name, true)
  end

  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end

end
