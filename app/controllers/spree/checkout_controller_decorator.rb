Spree::CheckoutController.class_eval do


  def before_transmitted
    flash[:notice] = t('transmit_notice')
    @person = current_person
    @school = current_school
    add = Spree::Address.where(:company => @school.name)
      .where(:firstname => @person.first_name)
      .where(:lastname => @person.last_name)
      .where(:address1 => @school.addresses.first.line1)
      .where(:city => @school.addresses.first.city).first
    if add
      @order.ship_address = add
      @order.bill_address = add
    else
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
    end

    @order.shipping_method_id = @order.line_items.first.product.shipping_category.shipping_methods.first
    redirect_to main_app.restock_path and return @order.save
  end

  def after_transmitted
    unless current_person.is_a? LeAdmin
      flash[:notice] = t('transmit_notice')
      redirect_to main_app.restock_path
    end
    true
  end



  def before_complete
    unless current_person.is_a? LeAdmin
      flash[:notice] = t('transmit_notice')
      redirect_to main_app.restock_path
      return false
    else
    end
    @person = current_person
    @school = current_school
    # Address

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
    # Trigger the purchase
    @order.next
    @order.save
    redirect_to main_app.restock_url
  end

  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end

end
