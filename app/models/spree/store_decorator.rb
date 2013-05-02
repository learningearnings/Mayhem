Spree::Store.class_eval do
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :code, :default, :email, :domains
end
