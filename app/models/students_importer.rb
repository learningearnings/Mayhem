class StudentsImporter < BaseImporter
  protected
  def run
    student_data.each do |datum|
      find_or_create_student(datum)
    end
  end

  def student_data
    parsed_doc.map do |student|
      {
        student: {
          first_name: student["First"],
          last_name: student["Last"],
          grade: student["Grade"],
          gender: student["Gender"],
        },
        school_id: @school.id,
        user: {
          username: student["Username"],
          password: student["Password"],
        }
      }
    end
  end

  def existing_school(school_id)
    School.find school_id
  end

  def find_or_create_student(datum)
    existing_student(datum) || create_student(datum)
  end

  def create_student(datum)
    begin
      Student.create(datum[:student], as: :admin).tap do |student|
        student << existing_school(datum[:school_id])
        user = student.user
        user.username = datum[:user][:username]
        user.password = datum[:user][:password]
        user.save(validate: false)
        student.activate!
      end
    rescue Exception => e
      warn "Got exception for #{datum.inspect} - #{e.inspect}"
    end
  end

  def existing_student(datum)
    users = Spree::User.where(username: datum[:user][:username])
    if users.present?
      users.select{|x| x.schools.include?(School.first)}.first.person
    else
      false
    end
  end
end
