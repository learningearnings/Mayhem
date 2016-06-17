ActiveAdmin.register SchoolCredit do
  filter :school_id  
  filter :school_name
  filter :district_guid
  filter :total_schools
  filter :amount
  filter :created_at

  menu :parent => "Bucks Distributed", :label => "School Credits"

  index do
    column :id
    column "School Id", :school_id
    column :school_name
    column :district_guid
    column "Teachers", :total_teachers
    column "Awarded Amount", :amount
    column "Date", :created_at
  end

end