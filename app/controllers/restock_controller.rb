class RestockController < LoggedInController
  def index
    @pending_shipments = Spree::Order.joins(:user).where('spree_users.id' => current_user).where(:state => ['pending','printed']).order('created_at desc')
    @order = Spree::Order.joins(:user).where('spree_users.id' => current_user).where(:state => ['cart','transmitted']).first
    respond_with(@pending_shipments, @cart)
  end
end
