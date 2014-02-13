ActiveAdmin.register School do

  filter :name
  filter :district_guid
  filter :sti_id
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
    column "STI District GUID", :district_guid
    column "STI id", :sti_id
    default_actions
  end

  form :partial => 'form'

  show do |school|
    admin_rows = []
    current_row = []
    row_number = column_number = 0
    admin_count = school.school_admins.count
    school.school_admins.each do |sa|
      current_row[column_number] = sa
      if (column_number += 1) > 7
        column_number = 0
        admin_rows[row_number] = current_row
        current_row = []
        row_number += 1
      end
    end
    admin_rows[row_number] = current_row if column_number > 0
    teacher_rows = []
    current_row = []
    row_number = column_number = 0
    teacher_count = school.teachers.count
    school.teachers.status_active.each do |t|
      current_row[column_number] = t
      if (column_number += 1) > 7
        column_number = 0
        teacher_rows[row_number] = current_row
        current_row = []
        row_number += 1
      end
    end
    teacher_rows[row_number] = current_row if column_number > 0
    student_rows = []
    current_row = []
    row_number = column_number = 0
    student_count = school.students.status_active.count
    school.students.includes(:user).status_active.each do |s|
      current_row[column_number] = s
      if (column_number += 1) > 7
        column_number = 0
        student_rows[row_number] = current_row
        current_row = []
        row_number += 1
      end
    end
    student_rows[row_number] = current_row if column_number > 0
    render 'school_show', teacher_count: teacher_count, admin_count: admin_count, student_count: student_count, admin_rows: admin_rows, teacher_rows: teacher_rows, student_rows: student_rows
  end
  controller do
    skip_before_filter :add_current_store_id_to_params
  end

end
