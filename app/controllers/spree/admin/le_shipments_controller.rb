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
        break if @order.state = current_state
      end
    end
    render :pdf => @order
  end


  def ship
    shipment = Spree::Order.find_by_number(params[:order_number]).shipment
    shipment.tracking = params[:tracking_number]
    shipment.shipping_method_id = params[:shipping_method]
    if shipment.ship
      flash[:notice] = "Order marked as shipped"
    else
      flash[:notice] = "There was an error shipping this order, please try again"
    end
    redirect_to admin_le_shipments_path
  end

end
