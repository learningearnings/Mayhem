class AuditLog < ActiveRecord::Base
  attr_accessible :person_id, :action, :person_name, :log_event_name, :district_guid, :school_id, :school_sti_id, :person_type, :person_sti_id
  attr_accessible :person_id, :action, :person_name, :log_event_name, :district_guid, :school_id, :school_sti_id, :person_type, :person_sti_id, :as => :admin
  belongs_to :log_event, polymorphic: true
  belongs_to :person, :foreign_key => :person_id

  scope :initiator, lambda { |person_id| joins("INNER JOIN people ON audit_logs.person_id = people.id").where("people.id = ?", person_id)}

  # def initiator
  # 	Person.find(self.person_id)
  # end
  
end
