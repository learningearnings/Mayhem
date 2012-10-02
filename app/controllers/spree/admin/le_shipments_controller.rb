class Spree::Admin::LeShipmentsController < Spree::Admin::BaseController

  def index
    @shipments = Spree::Order.where("shipment_state = ?", "ready")
  end

  def ship
    shipment = Spree::Order.find_by_number(params[:order_id]).shipment
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
