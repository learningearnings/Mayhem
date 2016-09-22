class AuditLog < ActiveRecord::Base
  attr_accessible :user_id
  belongs_to :log_event, polymorphic: true
  #belongs_to :initiator, :class_name => 'Spree::User', :foreign_key => :user_id
end
