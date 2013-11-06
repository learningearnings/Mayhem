class Spree::Admin::LeShipmentsController < Spree::Admin::BaseController
  def index
    shipped_to_school = Spree::ShippingMethod.find_by_name("Shipped To School")
    @shipments = Spree::Order.where(:state => ['cart','transmitted','printed'], :shipping_method => [shipped_to_school]).order('state desc')
  end

  def print
    @order = Spree::Order.find_by_number(params[:order_number])
    @address = @order.ship_address
    if @address.nil?
      flash[:notice] = "Order #{@order.number} doesn't have an address yet"
      redirect_to admin_le_shipments_path and return
    end

    if ['cart','transmitted'].include?(@order.state)
      while @order.state != 'printed' do
        current_state = @order.state
        @order.next
        @order.save
        break if @order.state = current_state
      end
    end
    render :pdf => @order
  end

  def ship
    @order = Spree::Order.find_by_number(params[:order_number])
    @person = current_person
    @school = current_school
    # Address
    @order.restock_items!    # shipping below will pull them out again....
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
    if @order.state != 'complete'
      while @order.state != 'complete' do
        current_state = @order.state
        @order.next
        @order.save
        break if @order.state == current_state
      end
    end

    @order.create_shipment!
    shipment = @order.shipment
    @order.restock_items!    # shipping below will pull them out again....
    redirect_to admin_le_shipments_path
    shipment.save
    @order.unstock_items! and flash[:notice] = "Error #{shipment.errors.messages} on shipment.ship" and return unless shipment.ship
    @order.unstock_items! and flash[:notice] = "Error on @order.next" and return unless @order.next
    @order.unstock_items! and flash[:notice] = "Error on @order.save" and return unless @order.save
    @order.update!
    @order.save
    flash[:notice] = "Order #{@order.number} is marked as complete and shipped"
  end

  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end
end
