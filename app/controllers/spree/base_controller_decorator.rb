Spree::BaseController.class_eval do
  def ssl_required?
    ssl_supported?
  end
end
