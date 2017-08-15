class StudentsImporter < BaseImporter
  REQUIRED_HEADERS = ["First", "Last", "Gender", "Username", "Password"]

  protected
  def run
    return false unless parsed_doc
    check_header(parsed_doc.headers)
    student_data.each do |datum|
      find_or_create_student(datum)
    end
  end

  def check_header(headers)
    err_msg = "Please provide the correct headers with the student spreadsheet"
    REQUIRED_HEADERS.each do |h|
      raise err_msg unless headers.include?(h)
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

  def find_or_create_student(datum)
    existing_student(datum) || create_student(datum)
  end

  def create_student(datum)
    begin
      Student.create(datum[:student], as: :admin).tap do |student|
        user = student.user
        user.username = datum[:user][:username]
        user.password = datum[:user][:password]
        user.save(validate: false)
        student.save
        p = PersonSchoolLink.create(:school_id => @school.id, :person_id => student.id)
      end
    rescue Exception => e
      warn "Got exception for #{datum.inspect} - #{e.inspect}"
    end
  end

  def existing_student(datum)
    users = Spree::User.where(username: datum[:user][:username])
    if users.present?
      _users = users.select{|x| x.schools.include?(@school.id)}
      if _users.present? && _users.first.present?
        _users.first.person
      else
        false
      end
    else
      false
    end
  end
end
