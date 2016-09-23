class AuditLog < ActiveRecord::Base
  attr_accessible :person_id
  belongs_to :log_event, polymorphic: true
  #belongs_to :initiator, :class_name => 'Spree::User', :foreign_key => :user_id

  scope :initiator, lambda { |person_id| joins("INNER JOIN people ON audit_logs.person_id = people.id").where("people.id = ?", person_id)}

   def initiator
   	Person.find(self.person_id)
   end
end
