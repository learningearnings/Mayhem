class Spree::Admin::LeShipmentsController < Spree::Admin::BaseController

  def index
    @shipments = Spree::Order.where(:state => ['cart','transmitted','printed']).order('state desc')
  end

  def print
    @order = Spree::Order.find_by_number(params[:order_number])
    @address = @order.ship_address
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
    if @order.state != 'shipped'
      while @order.state != 'shipped' do
        current_state = @order.state
        @order.next
        @order.save
        break if @order.state = current_state
      end
    end

    @order.next
    @order.save
    @order.update!
    @order.create_shipment!
    shipment = @order.shipment
    @order.restock_items!    # shipping below will pull them out again....
    redirect_to admin_le_shipments_path
    shipment.save
    @order.unstock_items! and flash[:notice] = "Error on shipment.reload" and return unless shipment.reload
    @order.unstock_items! and flash[:notice] = "Error on shipment.ship" and return unless shipment.ship
    @order.unstock_items! and flash[:notice] = "Error on shipment.save" and return unless shipment.save
    @order.unstock_items! and flash[:notice] = "Error on @order.save " and return unless @order.save
    @order.unstock_items! and flash[:notice] = "Error on @order.next "  and return unless @order.next
    @order.unstock_items! and flash[:notice] = "Error on @order.save #2" and return unless @order.save

  end


  private
  def current_person
    current_user.person
  end

  def current_school
    ::School.find(session[:current_school_id])
  end



end
