ActiveAdmin.register TeacherCredit do
  filter :school_id  
  filter :teacher_id  
  filter :teacher_name
  filter :district_guid
  filter :amount
  filter :credit_source
  filter :created_at

  menu :parent => "Bucks Distributed", :label => "Teacher Credits"

  index do
    column :id
    column "School Id", :school_id
    column "Teacher Id", :teacher_id
    column :teacher_name
    column :district_guid
    column "Awarded Amount", :amount
    column "Credit Source", :credit_source
    column "Date", :created_at
  end

end