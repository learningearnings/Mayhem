class BuckDistributor
  extend ActiveSupport::Memoizable
  DAILY_STUDENT_AMOUNT = 25

  def initialize(schools, credit_manager=CreditManager.new, last_school_processed=1)
    @schools = schools if schools
    @schools = get_schools unless schools
    @last_school_processed = last_school_processed
    @credit_manager = credit_manager
    @logfile = "/home/deployer/logs/buck_distributor_txns_#{Date.today.to_s}.log"
    log_txn "BuckDistributor --  started on #{Time.now}"
  end
 
  
  def get_schools
    if @last_school_processed
      whereStr = " WHERE schools.id >= #{@last_school_processed} "
    else
      whereStr = " "
    end
    sql = %Q(
      SELECT * from (
        SELECT DISTINCT schools.*
        FROM schools, person_school_links, people 
        WHERE schools.id = person_school_links.school_id AND people.id = person_school_links.person_id  
          AND schools.status = 'active' AND schools.district_guid is not null
          AND person_school_links.status = 'active'
          AND people.type IN ('Teacher', 'SchoolAdmin') 
        UNION
        SELECT DISTINCT schools.*
        FROM schools, person_school_links, people, spree_users 
        WHERE schools.id = person_school_links.school_id AND people.id = person_school_links.person_id AND spree_users.person_id = people.id 
          AND schools.status = 'active' AND schools.district_guid is null
          AND person_school_links.status = 'active'
          AND (spree_users.last_sign_in_at >= (now() - '1 month'::interval) OR people.created_at > (now() - '1 month'::interval))
          AND people.type IN ('Teacher', 'SchoolAdmin') 
     ) AS SCHOOLS 
    )
    sql = sql + whereStr + " ORDER BY schools.id "
    log_txn " School SQL: #{sql} "
    schools = School.find_by_sql(sql)
    return schools
  end

  def run
    handle_schools
    handle_teachers
    log_txn "BuckDistributor --  ended on #{Time.now}"
  end

  def handle_schools
    log_txn "BuckDistributor --  processing  #{@schools.size} schools at #{Time.now}"
    @schools.each do |school|
      log_txn "BuckDistributor --  revoke credits for school #{school.name} #{school.id}  $#{school.balance.to_s} "
      @credit_manager.revoke_credits_for_school(school, school.balance)
      pay_school(school)
    end
    log_txn "BuckDistributor --  end schools processing  at #{Time.now}"
  end

  def pay_school(school)
    log_txn "BuckDistributor --  pay school #{school.name} #{school.id}  $#{amount_for_school(school).to_s} "
    @credit_manager.issue_credits_to_school school, amount_for_school(school)
  end

  # 25 dollars per student per day
  def amount_for_school school
    days_in_month = Time.days_in_month(Time.now.month)
    days_left_in_month = (days_in_month - Time.now.day) + 1

    if school.district_guid
      DAILY_STUDENT_AMOUNT * days_left_in_month * school.students.count
    else
      DAILY_STUDENT_AMOUNT * days_left_in_month * active_students(school).count
    end
  end
  memoize :amount_for_school

  def handle_teachers
    log_txn "BuckDistributor --  handle teachers start at #{Time.now} "
    @schools.each_with_index do |school, idx |
      log_txn "  Pay teachers at #{school.name} #{school.id} -- school #{idx} of #{@schools.size} "
      teachers_to_pay(school, { hide_ignored: false }).each do |teacher|
        log_txn "    Pay teacher revoke remainder #{teacher.first_name} #{teacher.last_name} #{ teacher.id} $#{ teacher.main_account(school).balance.to_s }"
        revoke_remainder(school, teacher, teacher.main_account(school).balance)
      end
      teachers_to_pay(school, { hide_ignored: true }).each do |teacher|
        pay_teacher(school, teacher)
      end
    end
    log_txn "BuckDistributor --  handle teachers end at #{Time.now} "
  end

  def revoke_remainder(school, teacher, amount)
    @credit_manager.revoke_credits_for_teacher(school, teacher, amount)
  end

  def amount_for_teacher(school)
    amount_for_school(school) / teachers_to_pay(school, { hide_ignored: true }).count
  end
  memoize :amount_for_teacher

  def teachers_to_pay(school, options={})
    if school.district_guid or (school.credits_type == "child")
      teachers = school.teachers.joins(:person_school_links).where(person_school_links: { school_id: school.id, can_distribute_credits: true }).uniq
      options[:hide_ignored] ? teachers.not_ignored(school.id) : teachers
    else
      (school.teachers.recently_logged_in + school.teachers.recently_created).uniq
    end
  end
  memoize :teachers_to_pay

  def active_students(school)
    (school.students.recently_logged_in + school.students.recently_created).uniq
  end
  memoize :active_students

  def pay_teacher(school, teacher)
    log_txn "    Pay teacher #{teacher.first_name} #{teacher.last_name} #{ teacher.id} $#{ amount_for_teacher(school).to_s }"
    @credit_manager.monthly_credits_to_teacher school, teacher, amount_for_teacher(school)
  end
  
  def log_txn(msg)
    @txnlog = File.open(@logfile,"w+")
    @txnlog.puts " #{Time.now.to_s}: #{msg} "
    #@txnlog = File.open(@logfile, 'a'){ |f|
    #  f.puts "#{Time.now.to_s}: #{msg}"
    #}
    #@txnlog.write "#{Time.now.to_s}: #{msg}"
  end
end
