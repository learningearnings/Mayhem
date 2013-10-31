Spree::BaseController.class_eval do
  def ssl_required?
    ssl_supported?
  end

  def ssl_allowed?
    false
  end
end
