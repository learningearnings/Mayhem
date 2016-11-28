ActiveAdmin.register AuditLog do 
  filter :person_id
  filter :person_name
  filter :district_guid
  filter :school_id
  filter :log_event_type, as: :select, collection: [['Auction', 'Auction'], ['Classroom', 'Classroom'], ['Person', 'Person'], ['PersonSchoolLink','PersonSchoolLink'], ['PersonSchoolClassroomLink', 'PersonSchoolClassroomLink'], ['Reward','Spree::Product'], ['School','School']] 
  filter :log_event_name
  filter :action
  filter :created_at
  #filter :"subscription_billing_plan_name" , :as => :select, :collection => BillingPlan.all.map(&:name)
  index do
    column :id
    column :district_guid
    column :school_id
    column :school_sti_id
    column :person_id
    column :person_sti_id
    column :person_name
    column :person_type
    column :log_event_id
    column :log_event_type do |audit_log|
      if audit_log.log_event_type == "Spree::Product"
        "Reward"
      else
        audit_log.log_event_type
      end  
    end  
    column :log_event_name
    column :action
    column "Date", :created_at
  end
end
