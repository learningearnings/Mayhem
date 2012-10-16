Spree::Order.class_eval do

  def restock_items!
    line_items.each do |line_item|
      Spree::InventoryUnit.decrease(self, line_item.variant, line_item.quantity)
    end
  end


  def unstock_items!
    line_items.each do |line_item|
      Spree::InventoryUnit.increase(self, line_item.variant, line_item.quantity)
    end
  end


checkout_flow do
    go_to_state :transmitted
    go_to_state :printed
    # go_to_state :address
    # go_to_state :delivery
    # go_to_state :payment, :if => lambda { |order| order.payment_required? }
    # go_to_state :confirm, :if => lambda { |order| order.confirmation_required? }
    go_to_state :complete
    go_to_state :shipped
    #remove_transition :from => :delivery, :to => :confirm
  end

end
