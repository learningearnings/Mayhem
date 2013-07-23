ActiveAdmin::Comment.class_eval do
  attr_accessible :resource_type, :resource_id, :body, as: :admin
end
