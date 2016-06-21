ActiveAdmin.register SchoolCredit do
  filter :school_id, label: "School Id"
  filter :school_name
  filter :district_guid
  filter :total_schools
  filter :amount
  filter :created_at
  actions :all, :except => [:destroy, :edit, :new]
  menu :parent => "Bucks Distributed", :label => "School Credits"
  index do
    column :id
    column "School Id", :school_id
    column :school_name
    column :district_guid
    column "Teachers", :total_teachers
    column "Awarded Amount", :amount
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
        school_credit.school_id
      end  
      row :school_name do
        school_credit.school_name
      end  
      row :district_guid
      row :teachers do
        school_credit.total_teachers
      end  
      row :awarded_amount do
        school_credit.amount
      end  
      row :date do
        school_credit.created_at
      end  
    end
  end
end