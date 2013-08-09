Spree::Admin::OrdersController.class_eval do

  def new
    @order = Spree::Order.create
    # Tis should pull in: The currently available rewards where fulfillment_type == "Shipped For School Inventory"
    @school_inventory_items = Spree::Product.where(:fulfillment_type => "Shipped for School Inventory")
    respond_with(@order)
  end

  def edit
    respond_with(@order)
  end

  def update
    return_path = nil
    if @order.update_attributes(params[:order]) && @order.line_items.present?
      @order.update!
      unless @order.complete?
        # Jump to next step if order is not complete.
        return_path = admin_order_customer_path(@order)
      else
        # Otherwise, go back to first page since all necessary information has been filled out.
        return_path = admin_order_path(@order)
      end
    else
      @order.errors.add(:line_items, t('errors.messages.blank')) if @order.line_items.empty?
    end

    respond_with(@order) do |format|
      format.html do
        if return_path
          redirect_to return_path
        else
          render :action => :edit
        end
      end
    end
  end

end
