class Mobile::V1::Students::RewardsController < Mobile::V1::Students::BaseController
  
  def insufficient_quantity?
    variant  = Spree::Variant.where(product_id: params[:reward][:id]).first
    quantity = params[:reward][:purchase_quantity]
    return true if quantity.to_i > variant.count_on_hand
  end

  def insufficient_funds?
    variant  = Spree::Variant.where(product_id: params[:reward][:id]).first
    quantity = params[:reward][:purchase_quantity]
    #reload the product to refresh count_on_hand to account for another student purchasing at the same time 
    variant.reload    
    return true if current_person.checking_account.balance < (variant.price * quantity.to_i)
  end
  
  def purchase
    Rails.logger.debug("AKT: Mobile Rewards Controller params: #{params.inspect}")
    variant  = Spree::Variant.where(product_id: params[:reward][:id]).first
    quantity = params[:reward][:purchase_quantity]
    
    if insufficient_quantity?
      message = "Sorry, we don't have enough of that! Please try your order again."
      render json: { status: :unprocessible_entity, msg: message }   and return      
    end
    if insufficient_funds?
      message = "Sorry, you do not have enough credits to purchase this item."
      render json: { status: :unprocessible_entity, msg: message }  and return
    end
  
    ActiveRecord::Base.transaction do
      begin
        @order = Spree::Order.new
        @order.save  
        @order.add_variant(variant, quantity) if quantity > 0
        @order.unstock_items!
    
        # --- The above code is spree core copied ---
        # --- Start our customization ---
  
        if @order.total > current_person.checking_account.balance
          message = t(:not_enough_credits_to_purchase)
          product = @order.line_items.first.product
          @order.empty!
          render json: { status: :unprocessible_entity, msg: message }        
        else
          OneClickSpreeProductPurchaseCommand.new(@order, current_person, current_school, params[:reward][:teacher]).execute!
          message = "Purchase successful!"
          render json: { status: :ok, msg: message } and return
        end

      rescue => e
        message = 'There was an issue placing your order.'
        render json: { status: :unprocessible_entity, msg: message }        
        ActiveRecord::Rollback
      end
    end
  end
end