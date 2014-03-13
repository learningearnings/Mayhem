ActiveAdmin.register School do

  filter :name
  filter :state

  index do
    column :id
    column :avatar do |school|
      image_tag(school.logo.thumb('100x75!').url) if school.logo
    end
    column :name do |school|
      link_to(school.name, admin_school_path(school))
    end
    column :address do |school|
      school.address
    end
    column "Grades" do |school|
      school.min_grade.to_s + ' - ' + school.max_grade.to_s
    end
    column :school_phone
    column :mascot_name
    column :status
    column :timezone
    column "Distribution",:distribution_model
    column :store_subdomain
    default_actions
  end

  form :partial => 'form'

  show do |school|
    school_admins = school.school_admins
    teachers = school.teachers.status_active
    students = school.students.status_active.includes(:user)
    render 'school_show', teachers: teachers, students: students, school_admins: school_admins
  end

  controller do
    skip_before_filter :add_current_store_id_to_params
  end

end
