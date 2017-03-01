require 'powerschool-client'
require 'csv'
require 'json'
class PowerschoolConnector

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
  rescue Exception => e
    export_to_file("error.log", e, true)
    exit
  end

  def process
    write_organization_csv

    process_schools = lambda do |to_process|
      wait_thread = nil
      to_process.each do |school_id|
        write_users_and_levels_csv(school_id)

        wait_thread.join if wait_thread.is_a? Thread
        c = Thread.current["connector"]
        wait_thread = Thread.new do
          Thread.current["connector"] = c
          write_eclass_and_roster_csvs(school_id)
        end
      end
      wait_thread.join if wait_thread.is_a? Thread
    end

    school_len = @schools.size
    sthread1 = Thread.new do
      process_schools.call(@schools.values_at(*@schools.each_index.select(&:even?)))
    end

    if school_len > 1
      sthread2 = Thread.new do
        process_schools.call(@schools.values_at(*@schools.each_index.select(&:odd?)))
      end
    end

    sthread1.join
    sthread2.join if school_len > 1
    write_finished_status
  rescue => e
    dump_error_file_for(e)
    send_coolline_mail_for(e)
  end

  def client
    if !Thread.current["connector"]
      log "had to recreate powerschool client"
    end
    Thread.current["connector"] ||= Powerschool::Client.new(@connect_options)
  end

  def get_schools
    @import_dir = File.join(@import_dir, "tmp")

    results = client.get_schools.map {|school|
      {
        :name => school.name,
        :import_id => school.id
      }
    }

    results << get_district_office
    results = results.compact.sort_by{|h| h[:name]}
    export_to_csv("schools.csv", results, SCHOOL_COLUMNS, true)
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

    mutex = Mutex.new
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

    puts (return_file_path ? file :  "(#{Time.now}) wrote file #{file}")
  end

  def export_to_file(file, data, return_file_path=false)
    return unless data
    file = File.expand_path(File.join(@import_dir, file))
    FileUtils.mkdir_p File.dirname(file)
    File.open(file, 'w') { |f| f.write(data) }

    puts(return_file_path ? file :  "(#{Time.now}) wrote file #{file}")
  end

  def csv_dir
    File.expand_path("./csv_files/") # temporary home
  end

  def log(msg)
    unless @silence_log_messages
      puts "PowerschoolConnector: #{msg}"
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
