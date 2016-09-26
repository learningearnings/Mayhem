ActiveAdmin.register AuditLog do 
  filter :person_id
  filter :person_first_name, :as => :string
  filter :person_last_name, :as => :string
  filter :person_district_guid, :as => :string
  #filter :school, as: :select, collection: School.order(:id)
  filter :log_event_type
  filter :created_at
  #filter :"subscription_billing_plan_name" , :as => :select, :collection => BillingPlan.all.map(&:name)
  index do
    column :id
    column "District Id" do |audit_log|
      audit_log.person.district_guid
    end   
    column "School Id" do |audit_log|
      audit_log.person.school.id if !audit_log.person.is_a?(LeAdmin)
    end
    column "School sti_id" do |audit_log|
      audit_log.person.school.sti_id if !audit_log.person.is_a?(LeAdmin)
    end
    column "Person id" do |audit_log|
      audit_log.person.id
    end
    column "Person sti_id" do |audit_log|
      audit_log.person.sti_id if !audit_log.person.is_a?(LeAdmin)
    end
    column "Person Name" do |audit_log|
      audit_log.person.name
    end   
    column "Person Type" do |audit_log|
      audit_log.person.type
    end
    column "Object Id" do |audit_log|
      audit_log.log_event_id
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
    column "Action", :action
    column "Date", :created_at
  end
end
