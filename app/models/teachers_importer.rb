class TeachersImporter < BaseImporter
  protected
  def run
    teacher_data.each do |datum|
      find_or_create_teacher(datum)
    end
  end

  def teacher_data
    parsed_doc.map do |teacher|
      {
        teacher: {
          first_name: teacher["First"],
          last_name: teacher["Last"],
          grade: teacher["Grade"],
          gender: teacher["Gender"],
          email: teacher["Email Address"],
        },
        school_id: @school.id,
        user: {
          username: teacher["Username"],
          password: teacher["Password"],
          le_admin: teacher["LE Admin (Y/N)?"],
        }
      }
    end
  end

  def existing_school(school_id)
    School.find school_id
  end

  def find_or_create_teacher(datum)
    existing_teacher(datum) || create_teacher(datum)
  end

  def create_teacher(datum)
    begin
      person_class_for(datum).create(datum[:teacher], as: :admin).tap do |teacher|
        teacher << existing_school(datum[:school_id])
        user = teacher.user
        user.username = datum[:user][:username]
        user.password = datum[:user][:password]
        user.save(validate: false)
        PersonSchoolLink.create(person_id: teacher.id, school_id: @school.id)
      end
    rescue Exception => e
      warn "Got exception for #{datum.inspect} - #{e.inspect}"
    end
  end

  def existing_teacher(datum)
    users = Spree::User.where(username: datum[:user][:username])
    if users.present? && users.select{|x| x.schools.include?(School.first)}.first.present?
      users.select{|x| x.schools.include?(School.first)}.first.person
    else
      false
    end
  end

  def person_class_for(datum)
    if datum[:user][:le_admin] == 'Y'
      type = 'SchoolAdmin'
    else
      type = 'Teacher'
    end
    Kernel.const_get(type)
  end
end
