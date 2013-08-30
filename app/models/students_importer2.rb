class StudentsImporter2 < BaseImporter
  protected
  def run
    n, errs = 0, []

    parsed_doc.each do |row|
      n += 1

      # SKIP: header i.e. first row OR blank row
      next if n == 1 or row.join.blank?

      # build_from_csv method will map customer attributes & 
      # build new customer record
      build_from_csv(row)

      # Save upon valid 
      # otherwise collect error records to export
      if @student.valid?
        find_or_create_student
      else
        errs << row
      end
    end
  end

  def find_or_create_student
    existing_student || create_student
  end

  def csv_header
    @file.first
  end
  
  def build_from_csv(row)
    # find existing customer from email or create new
    @student = Student.new
    @student.attributes ={:first_name => row[0],
      :last_name => row[1],
      :grade => row[2],
      :gender => row[3]}
    @student.user.attributes = {
      :username => row[4],
      :password => row[5]}
  end
  
  def to_csv
    [first_name, last_name, email, phone, mobile, address, fax, city]
  end

  def create_student
    begin
      @student.save
      @student << existing_school(@school.id)
      @student.user.save(validate: false)
      @student.activate!
    rescue Exception => e
      warn "Got exception for #{@student} - #{e.inspect}"
    end
  end

  def existing_student
    users = Spree::User.where(username: @student.username)
    if users.present?
      users.select{|x| x.schools.include?(@school)}.first.person
    else
      false
    end
  end

end
