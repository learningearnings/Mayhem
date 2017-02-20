require 'powerschool-client'
require 'csv'
require 'json'
class PowerschoolImporter

  # attr_reader :district_id, :last_event_id, :use_local_files, :import_dir, :save_response_path, :coolline_address

  # note that these arrays determine the order of the columns in the csv file
  SCHOOL_COLUMNS = [:name, :import_id]
  ORGANIZATION_COLUMNS = [:import_id, :name, :parent_org_id]
  USERS_COLUMNS = [
    :import_id, :first_name, :middle_init, :last_name, :suffix, :nickname,
    :login, :password, :email, :user_type, :organization_id, :enabled, :display_id, :google_email_address
  ]
  CLASSES_COLUMNS = [:import_id, :name, :shortname, :description, :code, :year, :teacher_id, :organization_id]
  ROSTER_COLUMNS = [:class_id, :user_id, :role]
  USERS_LEVELS_COLUMNS = [:user_id, :level_id]

  def initialize(options)
    options['log_responses'] ||= false
    @silence_log_messages = options['silence_logging']
    @import_dir = File.join((options['import_dir'] || options[:import_dir]), "new_import")
    @schools = options['schools']
    @start_year = options['start_year']
    @teacher_user_ids = {}
    @teacher_ids = []
    @coteacher_manager = {}
    @coteacher_manager[:processed_coteachers] = []
    @coteacher_manager[:failed] = false
    @connect_options = options
    @coolline_address = options['coolline_address']
    @email_id = 1

  rescue Exception => e
    export_to_file("error.log", e, true)
    exit
  end
  
  def run
    @logger = File.open("sync.log","w")    
    ps_district = get_district
    @district = District.where(guid: ps_district[:guid]).first
    if !@district
      @district = District.new
      @district.guid = ps_district[:guid]
    end
    @district.name = ps_district[:name]
    @district.save
    @district_state = (State.where(abbr: ps_district[:state]).first.id)
    
    #deactivate all entities for this district
    #todo
    PersonSchoolClassroomLink.delete_all("created_at > '#{1.day.ago}'")
    Classroom.delete_all(district_guid: @district.guid) 
    PersonSchoolLink.delete_all("created_at > '#{1.day.ago}'")
    Spree::User.delete_all("created_at > '#{1.day.ago}'")    
    Person.delete_all(district_guid: @district.guid)        
    School.delete_all(district_guid: @district.guid)
    
    sync_schools
    
    @logger.puts "Success!"
    @logger.close
  
  end
  
  def run_school(school_id)
    @logger = File.open("sync.log","w")    
    ps_district = get_district
    @district = District.where(guid: ps_district[:guid]).first
    if !@district
      @district = District.new
      @district.guid = ps_district[:guid]
    end
    @district.name = ps_district[:name]
    @district.save
    @district_state = (State.where(abbr: ps_district[:state]).first.id)
    le_school = School.where(district_guid: @district.guid, sti_id: school_id).first
    sync_teachers(school_id, le_school.id)
    sync_students(school_id, le_school.id)
    sync_classrooms(school_id, le_school.id)
    
    @logger.puts "Success!"
    @logger.close
  
  end
  

  
  def sync_schools
    ps_schools = get_schools
    ps_schools.each do | school |
      
      le_school = School.where(district_guid: @district.guid, sti_id: school.id).first
      if !le_school
        le_school = School.new
        le_school.district_guid = @district.guid
      end
      le_school.sti_id = school.id
      le_school.legacy_school_id = school.school_number
      le_school.status = 'active'      
      le_school.name = school.name
      le_school.min_grade = school.low_grade
      le_school.max_grade = school.high_grade
      le_school.address1 = (school.try(:addresses) ? school.addresses["physical"]["street"] : "Fake Address"), 
      le_school.address1 = "Fake Address" unless le_school.address1
      le_school.city =  (school.try(:addresses) ? school.addresses["physical"]["city"] : "Fake City") 
      le_school.city = "Fake City" unless le_school.city
      le_school.state_id = @district_state 
      le_school.zip = (school.try(:addresses) ? school.addresses["physical"]["postal_code"] : "Fake Zip")
      le_school.zip = '00000' unless le_school.zip
      if !le_school.save
        @logger.puts "sync_schools: #{le_school.inspect}"     
        exit 
      end
      le_school.reload
      sync_teachers(school.id, le_school.id)
      sync_students(school.id, le_school.id)
      sync_classrooms(school.id, le_school.id)
      
    end
    
    #Distribute Bucks
    
    
  end
  
  def sync_teachers(school_id, le_school_id)
    staff = client.get_staff(school_id)
    staff.each do | teacher |
      puts teacher.inspect
      le_teacher = Teacher.where(district_guid: @district.guid, sti_id: teacher.id).first_or_initialize
      le_teacher.user = Spree::User.new unless le_teacher.user
      le_teacher.user.confirmed_at = Time.now
      le_teacher.status = "active"
      #le_teacher.dob = teacher.dob
      le_teacher.grade = 5
      le_teacher.first_name = teacher.first_name
      le_teacher.last_name = teacher.last_name  
      le_teacher.user.api_user = true
      email = teacher.emails["work_email"]
      le_teacher.user.email = email 
      le_teacher.user.username = teacher.teacher_username     
      if !le_teacher.save(validate: false)
        @logger.puts "Error saving teacher: "
        @logger.puts "PS Teacher: #{teacher.inspect}"  
        @logger.puts "LE Teacher: #{le_teacher.inspect}"          
        exit
      end      
      le_teacher.reload      

      if !le_teacher.user.save(validate: false)
        @logger.puts "Error saving teacher user: "
        @logger.puts "LE Teacher: #{le_teacher.inspect}" 
        @logger.puts "PS Teacher User: #{le_teacher.user.inspect}"                   
        exit
      end          

      #update person school links
      psl = PersonSchoolLink.where(person_id: le_teacher.id, school_id: le_school_id).first
      if !psl
        psl = PersonSchoolLink.new
        psl.person_id = le_teacher.id
        psl.school_id = le_school_id
      end
      psl.status = 'active'
  
      if !psl.save(validate: false)
        @logger.puts "Teacher: #{le_teacher.inspect}"
        @logger.puts "PSL: #{psl.inspect}" 
        exit
      end      
    end
  end

  def sync_students(school_id, le_school_id)
    students = client.get_students(school_id, 'contact_info,school_enrollment')
    students.each do | student |
      
      le_student = Student.where(district_guid: @district.guid, sti_id: student.id).first_or_initialize
      le_student.user = Spree::User.new unless le_student.user
      le_student.user.confirmed_at = Time.now
      #todo
      le_student.gender = "M"
      le_student.first_name = student.first_name
      le_student.last_name = student.last_name
      le_student.grade  = student.school_enrollment["grade_level"]
      le_student.status = "active"
      le_student.user.api_user = false
      if le_student.recovery_password.nil?
        username = generate_username_for_district(@district.guid, student.first_name, student.last_name)
        password = UUIDTools::UUID.random_create.to_s[0..3]
        le_student.user.username = username
        le_student.user.password = password
        le_student.user.password_confirmation = password 
      end 
      if !le_student.save
        @logger.puts "Error saving student: "
        @logger.puts "PS Student: #{student.inspect}"  
        @logger.puts "LE Student: #{le_student.inspect}"          
        exit
      end         
      le_student.reload
      if le_student.user.username.blank?
        username = generate_username_for_district(@district.guid, student.first_name, student.last_name)
        password = UUIDTools::UUID.random_create.to_s[0..3]
        le_student.user.username = username
        le_student.user.password = password
        le_student.user.password_confirmation = password 
      end 
      if !le_student.user.save
         @logger.puts "Error:"
         @logger.puts "LE Student user #{le_student.user.inspect}"
         @logger.puts ""
         exit
      end
        
      #update person school links
      psl = PersonSchoolLink.where(person_id: le_student.id, school_id: le_school_id).first
      if !psl
        psl = PersonSchoolLink.new
        psl.person_id = le_student.id
        psl.school_id = le_school_id
      end
      psl.status = 'active'
      
      if !psl.save(validate: false)
        @logger.puts "Error:"
        @logger.puts "Student: #{le_student.inspect}"
        @logger.puts "PSL: #{psl.inspect}" 
        exit
      end 
    end
  end
  
  def sync_classrooms(school_id, le_school_id)
    sr = get_sections(school_id)
    sections = sr[0]
    enrollments = sr[1]
    load_sections(sections, le_school_id)
    load_enrollments(enrollments, le_school_id)
  end
  
  def load_sections(sections, le_school_id)
    @logger.puts "Loading #{sections.size} sections for school #{le_school_id}: #{sections.inspect}"
    sections.each do | section |
      @logger.puts "Processing #{section[:import_id]} section  #{section.inspect}"
      cr = Classroom.where(district_guid: @district.guid, school_id: le_school_id, sti_id: section[:import_id]).first
      if !cr
        cr = Classroom.new
        cr.district_guid = @district.guid
      end
      cr.school_id = le_school_id
      cr.sti_id = section[:import_id]
      cr.name = section[:name]            
      if !cr.save
        @logger.puts "Error saving classroom #{cr.inspect}"
        exit
      end
      cr.reload
      @logger.puts("Updated classroom: #{cr.inspect}")
      teacher = Teacher.where(district_guid: @district.guid, sti_id: section[:staff_id]).first
      if teacher
        psl = PersonSchoolLink.where(school_id: le_school_id, person_id: teacher.id).first
        next if !psl
        pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: cr.id).first
        if !pscl
          pscl = PersonSchoolClassroomLink.new
          pscl.person_school_link_id = psl.id
          pscl.classroom_id = cr.id
        end
        pscl.status = "active"
        if !pscl.save(validate: false)
          @logger.puts "Error saving teacher school classroom link #{pscl.inspect}"
          exit
        end
      else
        @logger.puts "Section: #{section.inspect}"
        @logger.puts "Error no teacher found with sti_id: #{section[:staff_id]}"
        next
      end    
  end
  
  def load_enrollments(enrollments, le_school_id)
    @logger.puts "Processing enrollments for school #{le_school_id}"
    enrollments.each do | enrollment |
      @logger.puts "Processing enrollment #{enrollment.inspect}"
      student = Student.where(district_guid: @district.guid, sti_id: enrollment[:user_id]).first
      if student
        psl = PersonSchoolLink.where(school_id: le_school_id, person_id: student.id).first
        next if !psl
        cr = Classroom.where(district_guid: @district.guid, school_id: le_school_id, sti_id: enrollment[:class_id]).first
        if !cr
          @logger.puts "Enrollment: #{enrollment.inspect}"
          @logger.puts "Could not find classroom for school #{le_school_id} and sti_id: #{enrollment[:class_id]} "
          next
        end              
        pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: cr.id).first
        if !pscl
          pscl = PersonSchoolClassroomLink.new
          pscl.person_school_link_id = psl.id
          pscl.classroom_id = cr.id
        end
        pscl.status = "active"
        if !pscl.save(validate: false)
          @logger.puts "Error saving student school classroom link #{pscl.inspect}"
          exit
        end
      else
        @logger.puts "Enrollment: #{enrollment.inspect}"        
        @logger.puts "Error:  no student found with id: #{enrollment[:user_id]}"
        next
      end
    end   
  end
    
  end
  
  def get_sections(school_id)
    return if school_id.to_s == "0"
    eclasses, roster = [], []
    @term_start_years ||= {}
    #
    sections = client.get_sections(school_id, @start_year)
    enrollment_precaching = prerequest_section_enrollments(sections)

    term_ids = sections.map{|s| s.term_id}.uniq!

    if term_ids
      mutex = Mutex.new

      term_ids.each do |t|
        mutex.synchronize do
          @term_start_years[t] = client.get_term(t).start_year
        end
      end
    end

    enrollment_precaching.each do |t|
      t.join
    end
    sections.each do |section|
      eclasses << map_section_to_haiku_eclass(section)

      section.enrollments.each do |enrollment|
        if !enrollment.dropped
          roster << {
            :class_id => enrollment.section_id,
            :user_id  => enrollment.student_id,
            :role     => 'S'
          }
        end
      end
    end 
    return [eclasses,roster]
  end

  
  # Recursively generate usernames until we find one that is unique
  def generate_username_for_district(district_guid, first_name, last_name, iteration = 0)
    username = first_name.downcase[0] + last_name.downcase[0..4]
    username += iteration.to_s if iteration > 0
    return username if username_unique_for_district?(district_guid, username)
    return generate_username_for_district(district_guid, first_name, last_name, iteration + 1)
  end

  def username_unique_for_district?(district_guid, username)
    !Student.joins(:user).where(:district_guid => district_guid, :user => {:username => username}).any?
  end



  def client
    if !Thread.current["connector"]
      log "had to recreate powerschool client"
    end
    Thread.current["connector"] ||= Powerschool::Client.new(@connect_options)
  end

  def get_schools
    
    ps_schools = client.get_schools
    @logger.puts "Importer last school: #{ps_schools.last.inspect}"
    ps_schools
  end

  def get_district
    response = client.get_district
    @logger.puts "Importer get_district response2: #{response.inspect}"
    @logger.puts "Importer get_district response2: #{response["district"]["addresses"].inspect}"    
    district = 
      {
       :guid => response["district"]["uuid"],
       :sti_id => response["district"]["district_number"],
       :name => response["district"]["name"], 
       :state => response["district"]["addresses"]["physical"]["state_province"]
     }
    return district
  rescue RestClient::ResourceNotFound    
  end

  def get_district_office(include_parent_org_column=false)
    response = client.get_school(0)
    district_office = {:name => response.name, :import_id => response.id}
    district_office[:parent_org_id] = '' if include_parent_org_column
    return district_office
  rescue RestClient::ResourceNotFound
  end

  def write_users_and_levels_csv(school_id)
    users, users_levels = [], []

    client.get_students(school_id, 'contact_info,school_enrollment').each do |student|
      users << map_student_to_haiku_eclass(student, school_id)
      users_levels << {:user_id => student.id, :level_id => student.school_enrollment["grade_level"]} if student.school_enrollment
    end

    mutex = Mutex.newreload!
    client.get_staff(school_id).each do |teacher|
      mutex.synchronize do
        @teacher_ids << teacher.id
        @teacher_user_ids[teacher.id] = teacher.user_id
      end
      users << map_teacher_to_haiku_eclass(teacher, school_id)
    end

    export_to_csv("users.csv.pass1.#{school_id}", users, USERS_COLUMNS)
    export_to_csv("users_levels.csv.pass1.#{school_id}", users_levels, USERS_LEVELS_COLUMNS) unless users_levels.empty?
  end

  def write_organization_csv
    orgs = []

    client.get_schools.each do |school|
      if @schools.include?(school.id.to_s)
        orgs << {
          :import_id     => school.id,
          :name          => school.name,
          :parent_org_id => ''
        }
      end
    end

    orgs << get_district_office(true) if @schools.include?("0")
    export_to_csv("organizations.csv.pass1", orgs, ORGANIZATION_COLUMNS)
  end

  def prerequest_section_enrollments(sections)
    c = client

    threads = []
    threads << Thread.new do
      Thread.current["connector"] = c
      sections.values_at(*sections.each_index.select(&:even?)).map do |sec|
        sec.enrollments
      end
    end
    if sections.size > 1
      threads << Thread.new do
        Thread.current["connector"] = c
        sections.values_at(*sections.each_index.select(&:odd?)).map do |sec|
          sec.enrollments
        end
      end
    end
    return threads
  end

  def write_eclass_and_roster_csvs(school_id)
    # A SchoolId of 0 means District Office, which can not have classes
    return if school_id.to_s == "0"
    eclasses, roster = [], []
    @term_start_years ||= {}
    #
    sections = client.get_sections(school_id, @start_year)
    enrollment_precaching = prerequest_section_enrollments(sections)

    term_ids = sections.map{|s| s.term_id}.uniq!

    if term_ids
      mutex = Mutex.new

      term_ids.each do |t|
        mutex.synchronize do
          @term_start_years[t] = client.get_term(t).start_year
        end
      end
    end

    enrollment_precaching.each do |t|
      t.join
    end
    sections.each do |section|
      eclasses << map_section_to_haiku_eclass(section)

      section.enrollments.each do |enrollment|
        if !enrollment.dropped
          roster << {
            :class_id => enrollment.section_id,
            :user_id  => enrollment.student_id,
            :role     => 'S'
          }
        end
      end
    end

    if coteacher_setting_appears_disabled?
      log "Skipping coteachers as the endpoint appears out of service"
    else
      roster += get_coteacher_data unless @teacher_ids.empty?
    end

    export_to_csv("classes.csv.pass1.#{school_id}", eclasses, CLASSES_COLUMNS)
    export_to_csv("roster.csv.pass1.#{school_id}", roster, ROSTER_COLUMNS)
  end

  def coteachers_to_process
    mutex = Mutex.new
    mutex.synchronize do
      @teacher_ids - @coteacher_manager[:processed_coteachers] rescue []
    end
  end

  def mark_coteacher_processed(teacher_id)
    mutex = Mutex.new
    mutex.synchronize do
      @coteacher_manager[:processed_coteachers] << teacher_id
    end
  end

  def coteacher_setting_appears_disabled?
    !!@coteacher_manager[:failed]
  end

  def mark_coteacher_feature_disabled
    mutex = Mutex.new
    mutex.synchronize do
      @coteacher_manager[:failed] = true
    end
  end

  def get_coteacher_data
    coteacher_roster_data = []

    coteachers_to_process.each do |teacher_id|
      data = client.get_coteacher_sections(teacher_id)

      if data
        client.get_coteacher_sections(teacher_id).each do |t_id, section_ids|
          section_ids.each do |section_id|
            coteacher_roster_data << {
              :class_id => section_id,
              :user_id  => "T#{t_id}",
              :role     => 'T'
            }
          end
        end
      end

      mark_coteacher_processed(teacher_id)
    end

    coteacher_roster_data
  rescue => e
    if e.respond_to?(:response) && e.response
      log "Disabling coteacher feature because it responded #{e.response}"
    else
      log "Disabling coteacher feature because it wouldn't respond to response"
    end
    mark_coteacher_feature_disabled
    return []
  end

  def map_student_to_haiku_eclass(student, school_id)
    {
      :import_id            => student.id, #or maybe id?
      :first_name           => student.first_name,
      :middle_init          => '',
      :last_name            => student.last_name,
      :suffix               => '',
      :nickname             => '',
      :login                => student.student_username,
      :password             => '',
      :email                => student.contact_info["email"],
      :user_type            => 'S',
      :organization_id      => school_id,
      :enabled              => '1',
      :display_id           => '',
      :google_email_address => ''
    }
  end

  def map_teacher_to_haiku_eclass(teacher, school_id)
    {
      :import_id            => "T#{@teacher_user_ids[teacher.id]}",
      :first_name           => teacher.first_name,
      :middle_init          => '',
      :last_name            => teacher.last_name,
      :suffix               => '',
      :nickname             => '',
      :login                => teacher.teacher_username,
      :password             => '',
      :email                => teacher.emails["work_email"],
      :user_type            => 'T',
      :organization_id      => school_id,
      :enabled              => '1',
      :display_id           => '',
      :google_email_address => ''
    }
  end

  def map_section_to_haiku_eclass(section)
    if section.staff_id.nil?
      log("WARNING, skipping teacherless class #{section.inspect}")
      return
    end

    section_name = "#{section.course.course_name} (#{section.section_number})"
    period = /([0-9]+)/.match(section.expression)
    section_name += " - #{period.to_s}" if period

    {
      :import_id        => section.id,
      :name             => section_name,
      :shortname        => '',
      :description      => '',
      :code             => section.course.course_number,
      :year             => @term_start_years[section.term_id],
      :teacher_id       => "T#{@teacher_user_ids[section.staff_id]}",
      :staff_id         => section.staff_id,
      :organization_id  => section.school_id
    }
  end

  def export_to_csv(file, data, keys, return_file_path=false)
    return unless data
    file = File.expand_path(File.join(@import_dir, file))

    FileUtils.mkdir_p File.dirname(file)
    csv = CSV.open(file, "w", :force_quotes=>true, :row_sep=>"\n")
    csv << keys.map {|k| k.to_s}

    data.compact.each do |row|
      line = keys.inject([]) {|array, key| array << row[key] }
      csv << line
    end
    csv.close

    @logger.puts (return_file_path ? file :  "(#{Time.now}) wrote file #{file}")
  end

  def export_to_file(file, data, return_file_path=false)
    return unless data
    file = File.expand_path(File.join(@import_dir, file))
    FileUtils.mkdir_p File.dirname(file)
    File.open(file, 'w') { |f| f.write(data) }

    @logger.puts(return_file_path ? file :  "(#{Time.now}) wrote file #{file}")
  end

  def csv_dir
    File.expand_path("./csv_files/") # temporary home
  end

  def log(msg)
    unless @silence_log_messages
      @logger.puts "PowerschoolConnector: #{msg}"
    end
  end

  def status_file_path(file_name)
    # NOTE: if you change this, change PowerschoolConverter too -- both need to agree on the filename
    FileUtils.mkdir_p(@import_dir)
    File.expand_path File.join(@import_dir, "#{file_name}.log")
  end

  def dump_error_file_for(error)
    msg = "#{Time.now.utc} \n#{error.class}: #{error.message}\n #{error.backtrace}\n"
    log "ERROR: #{error.class}, writing details to file: #{status_file_path('error')}\n"
    log msg

    File.open(status_file_path('error'), 'w') do |file|
      file.write msg
    end
  end

  def write_finished_status
    msg = "Data pull finished at #{Time.now.utc}.\n"

    File.open(status_file_path('finished'), 'w') do |file|
      file.write msg
    end
  end

  def coolline_address
    @coolline_address
  end

  def send_coolline_mail_for(error)
    return unless coolline_address
    `cat "#{error_file_path}" |mail -s "PowerSchoolConnector failed: #{error.message}" "#{coolline_address}"`
  end

  ## make this run as a standalone script
  if $0 == __FILE__
    raise "Invalid arguments: this script expects a single argument, a json-formatted options hash!" unless ARGV.size == 1

    opts = JSON.parse ARGV[0]
    entry_point = opts.delete('entry_point') or raise "When running this script directly, you must provide an :entry_point in the options!"

    connector = PowerschoolConnector.new opts
    connector.send entry_point
  end

end
