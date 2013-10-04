Spree::Order.class_eval do

  attr_accessible :school_id

  def school
    ::School.find(school_id)
  rescue
    nil
  end

  def restock_items!
    line_items.each do |line_item|
      Spree::InventoryUnit.decrease(self, line_item.variant, line_item.quantity)
    end
  end

  # NOTE: I do not think this is good code, but it's an extraction of something
  # that was (a) in a view, and (b) broken.  This is the 'correct' way to do
  # what the view was trying and failing to do in one line with comical rescues
  # and whatnot.
  def le_shipment_company
    output = if ship_address
               ship_address.company
             else
               ridiculous_yaml_setup = YAML.load(special_instructions.to_s)
               if(ridiculous_yaml_setup.is_a?(Hash))
                 school_id_from_ridiculous_yaml_setup = ridiculous_yaml_setup[:school_id]
                 school = School.find(school_id_from_ridiculous_yaml_setup)
                 if(school)
                   school.name
                 end
               end
             end
    output.to_s
  end


  def unstock_items!
    line_items.each do |line_item|
      Spree::InventoryUnit.increase(self, line_item.variant, line_item.quantity)
    end
  end

  def after_refund
    # restock item quantity
    variant = products.first.master
    # to get qty, we can call the first line_item since we are using one_click_spree_product_purchase_command and there is only one line-item per order
    variant.count_on_hand += line_items.first.quantity
    variant.save
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
    go_to_state :refunded
    #remove_transition :from => :delivery, :to => :confirm
  end

end
