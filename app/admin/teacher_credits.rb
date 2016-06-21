ActiveAdmin.register TeacherCredit do
  filter :school_id, label: "School Id"
  filter :teacher_id, label: "Teacher Id"
  filter :teacher_name
  filter :district_guid
  filter :amount
  filter :credit_source
  filter :reason
  filter :created_at
  actions :all, :except => [:destroy, :edit, :new]
  menu :parent => "Bucks Distributed", :label => "Teacher Credits"

  index do
    column :id
    column "School Id", :school_id
    column "Teacher Id", :teacher_id
    column :teacher_name
    column :district_guid
    column "Awarded Amount", :amount
    column "Credit Source", :credit_source
    column "Reason", :reason
    column "Date", :created_at
    column "" do |resource|
      links = ''.html_safe
      links += link_to "View", resource_path(resource), :class => "member_link edit_link"
      links
    end
  end
  show do
    attributes_table do
      row :id
      row "School Id" do
        teacher_credit.school_id
      end  
      row "Teacher Id" do
        teacher_credit.teacher_id
      end  
      row "Teacher Name" do
        teacher_credit.teacher_name
      end  
      row :district_guid  
      row :awarded_amount do
        teacher_credit.amount
      end
      row :credit_source do
        teacher_credit.credit_source
      end  
      row :reason do
        teacher_credit.reason
      end
      row :date do
        teacher_credit.created_at
      end  
    end
  end
end