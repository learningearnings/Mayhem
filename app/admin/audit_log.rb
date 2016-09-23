ActiveAdmin.register AuditLog do
  index do
    column :id
    column "District Id" do |audit_log|
      audit_log.initiator.district_guid
    end   
    column "School Id" do |audit_log|
      audit_log.initiator.school.id if !audit_log.initiator.is_a?(LeAdmin)
    end
    column "School sti_id" do |audit_log|
      audit_log.initiator.school.sti_id if !audit_log.initiator.is_a?(LeAdmin)
    end
    column "Person id" do |audit_log|
      audit_log.initiator.id
    end
    column "Person sti_id" do |audit_log|
      audit_log.initiator.sti_id if !audit_log.initiator.is_a?(LeAdmin)
    end
    column "Person Name" do |audit_log|
      audit_log.initiator.name
    end   
    column "Person Type" do |audit_log|
      audit_log.initiator.type
    end
    column "Object Type" do |audit_log|
      audit_log.log_event_type
    end
    column "Object Name" do |audit_log|
      if audit_log.log_event_type == 'Auction'
        audit_log.log_event.product.name
      elsif audit_log.log_event_type == "PersonSchoolLink" || audit_log.log_event_type == "PersonSchoolClassroomLink"
        audit_log.log_event.person.name
      else
        audit_log.log_event.try(:name)
      end  
    end 
    column "Date", :created_at
  end
end
