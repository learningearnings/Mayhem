Spree::Admin::OrdersController.class_eval do

  def new
    # Tis should pull in: The currently available rewards where fulfillment_type == "Shipped For School Inventory"
    @school_inventory_items = Spree::Product.shipped_for_school_inventory.active
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

  def quantities_pass?
    failed_qtys = []
    params[:product_quantities].each do |product_id, qty|
      product = Spree::Product.find product_id
      unless qty.to_i <= product.count_on_hand
        failed_qtys << product_id
      end
    end
    failed_qtys.empty?
  end

  def create_manual_order
    order = current_user.orders.create
    order.school_id = params[:school]
    order.shipping_method_id = Spree::ShippingMethod.find_by_name("Shipped To School").id
    order.save
    if quantities_pass?
      params[:product_quantities].each do |product_id, quantity|
        next if quantity.to_i == 0 # Don't add line items for zero quantity items
        product = Spree::Product.find product_id
        # add line_items to order from product variants
        variant = Spree::Variant.where(:product_id => product_id).first
        order.line_items.create(variant_id: variant.id, quantity: quantity)
        # remove count_on_hand from variant as the quantity requested
        variant.count_on_hand -= quantity.to_i
        variant.save
        opts = {:master_product => product, :school => School.find(params[:school]), :quantity => quantity, :retail_price => product.price}
        distributor = SchoolStoreProductDistributionCommand.new(opts)
        distributor.execute!
      end

      until order.complete?
        # move order along until complete
        order.next
      end

      redirect_to admin_orders_path
    else
      flash[:error] = "Check quantities.  Count on hand is lower than requested quantity."
      render :new
    end
  end

  def refresh_school_rewards
    @school = School.find(params[:school_id])
    @school_inventory_items = Spree::Product.shipped_for_school_inventory.not_excluded(@school).active
  end
end
