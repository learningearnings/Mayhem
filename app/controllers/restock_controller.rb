class RestockController < LoggedInController
  def index
    @pending_shipments = Spree::Order.joins(:user).where('spree_users.id' => current_user).where(:state => ['transmitted','pending','printed','complete','shipped']).where("#{Spree::Order.table_name}.created_at > ?",Time.now - 2.weeks ).order("#{Spree::Order.table_name}.created_at desc").limit(4)
    @transmitted = Spree::Order.joins(:user).where('spree_users.id' => current_user).where(:state => ['transmitted']).where("#{Spree::Order.table_name}.created_at > ?",Time.now - 2.weeks ).exists?
    @order = Spree::Order.joins(:user).where('spree_users.id' => current_user).where(:state => ['cart']).first
    respond_with(@pending_shipments, @order,@transmitted)
  end
end
