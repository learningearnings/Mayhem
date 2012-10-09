ActiveAdmin.register School do

  index do
    column :id
    column :name do |school|
      a = school.addresses.first
      output = []
      output << link_to(school.name, admin_school_path(school))
      if a
        output << a.line1
        output << a.line2 unless a.line2.blank?
        output << "#{a.city} #{a.state.abbr} #{a.zip}"
      end
      output.join('<br />').html_safe
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
  end

 
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
    school.teachers.each do |t|
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
    student_count = school.students.count
    school.students.each do |s|
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
 
end
