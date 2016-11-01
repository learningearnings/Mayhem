class BuckDistributor
  extend ActiveSupport::Memoizable
  DAILY_STUDENT_AMOUNT = 25

  def initialize(schools, credit_manager=CreditManager.new, last_school_processed=1)
    @schools = schools if schools
    @last_school_processed = last_school_processed
    @credit_manager = credit_manager
    @logfile = "/home/deployer/logs/buck_distributor_txns_#{Date.today.to_s}.log"
    log_txn "BuckDistributor --  started on #{Time.now}"
    @schools = get_schools unless schools
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
  
  def run_bonus
    handle_school_bonus
  end

  def handle_schools
    log_txn "BuckDistributor --  processing  #{@schools.size} schools at #{Time.now}"
    @schools.each do |school|
      log_txn "BuckDistributor --  revoke credits for school #{school.name} #{school.id}  $#{school.balance.to_s} "
      @credit_manager.revoke_credits_for_school(school, school.balance)
      pay_school_bonus(school)
    end
    log_txn "BuckDistributor --  end schools processing  at #{Time.now}"
  end

  def pay_school(school)
    amount_school = amount_for_school(school)
    log_txn "BuckDistributor --  pay school #{school.name} #{school.id}  $#{amount_school.to_s} "
    @credit_manager.issue_credits_to_school school, amount_school
    teachers_paid = (teachers_to_@schools.each do |school|pay(school, { hide_ignored: false }) + teachers_to_pay(school, { hide_ignored: true })).uniq
    school_credit = SchoolCredit.new(school_id: school.id, school_name: school.name, district_guid: school.district_guid, total_teachers: teachers_paid.count, amount: amount_school)

    if school_credit.save
      log_txn "BuckDistributor -- saving school credits for #{school.name} #{school.id} school credit id #{school_credit.id}"
    else
      log_txn "BuckDistributor -- unable to save school credits for #{school.name} #{school.id}"
    end 
    
    bonus_amount_school = bonus_amount_for_school(school)
    log_txn "BuckDistributor --  pay bonus school #{school.name} #{school.id}  $#{bonus_amount_school.to_s} "
    @credit_manager.issue_bonus_credits_to_school school, bonus_amount_school
    teachers_paid = (teachers_to_pay(school, { hide_ignored: false }) + teachers_to_pay(school, { hide_ignored: true })).uniq
    school_credit = SchoolCredit.new(school_id: school.id, school_name: school.name, district_guid: school.district_guid, total_teachers: teachers_paid.count, amount: bonus_amount_school)


    if school_credit.save
      log_txn "BuckDistributor -- saving school bonus credits for #{school.name} #{school.id} school credit id #{school_credit.id}"
    else
      log_txn "BuckDistributor -- unable to save bonus school credits for #{school.name} #{school.id}"
    end  
  end  
  
  def handle_school_bonus
    @schools.each do |school|
      
      bonus_amount_school = bonus_amount_for_school(school)
      log_txn "BuckDistributor --  pay bonus school #{school.name} #{school.id}  $#{bonus_amount_school.to_s} "
      @credit_manager.issue_bonus_credits_to_school school, bonus_amount_school
      teachers_paid = (teachers_to_pay(school, { hide_ignored: false }) + teachers_to_pay(school, { hide_ignored: true })).uniq
      school_credit = SchoolCredit.new(school_id: school.id, school_name: school.name, district_guid: school.district_guid, total_teachers: teachers_paid.count, amount: bonus_amount_school)
  
  
      if school_credit.save
        log_txn "BuckDistributor -- saving school bonus credits for #{school.name} #{school.id} school credit id #{school_credit.id}"
      else
        log_txn "BuckDistributor -- unable to save bonus school credits for #{school.name} #{school.id}"
      end  
    end
  end

  # 25 dollars per student per day
  def amount_for_school school
    days_in_month = Time.days_in_month(Time.now.month)
    days_left_in_month = (days_in_month - Time.now.day) + 1

    if school.district_guid
      amount_school = DAILY_STUDENT_AMOUNT * days_left_in_month * school.students.count
    else
      amount_school = DAILY_STUDENT_AMOUNT * days_left_in_month * active_students(school).count
    end
    #amount_school = amount_school * ((school.admin_credit_percent.to_f/100)+1)
  end
  memoize :amount_for_school 
  
    # 25 dollars per student per day
  def bonus_amount_for_school school
    days_in_month = Time.days_in_month(Time.now.month)
    days_left_in_month = (days_in_month - Time.now.day) + 1

    if school.district_guid
      amount_school = DAILY_STUDENT_AMOUNT * days_left_in_month * school.students.count
    else
      amount_school = DAILY_STUDENT_AMOUNT * days_left_in_month * active_students(school).count
    end
    bonus_amount_school = (amount_school * (school.admin_credit_percent.to_f/100.0)).round
  end
  memoize :bonus_amount_for_school 

  def handle_teachers
    log_txn "BuckDistributor --  handle teachers start at #{Time.now} "
    @schools.each_with_index do |school, idx |
      log_txn "  Pay teachers at #{school.name} #{school.id} -- school #{idx} of #{@schools.size} "
      teachers_to_pay(school, { hide_ignored: false }).each do |teacher|
        log_txn "    Pay teacher revoke remainder #{teacher.first_name} #{teacher.last_name} #{ teacher.id} $#{ teacher.main_account(school).balance.to_s }"
        if revoke_remainder(school, teacher, teacher.main_account(school).balance)
          teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: school.id, teacher_name: teacher.name, district_guid: school.district_guid, amount: teacher.main_account(school).balance, credit_source: "SYSTEM", reason: "Reset monthly balance")
          if teacher_credit.save
            log_txn "    Saving Teacher credit for #{teacher.first_name} #{teacher.last_name} #{ teacher.id} teacher credit id #{teacher_credit.id}"
          else
            log_txn "    Unable to save teacher credit for #{teacher.first_name} #{teacher.last_name} #{ teacher.id}"
          end  
        end  

      end
      teachers_to_pay(school, { hide_ignored: true }).each do |teacher|
        amount_for_teacher = amount_for_teacher(school)
        if pay_teacher(school, teacher,amount_for_teacher)
          teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: school.id, teacher_name: teacher.name, district_guid: school.district_guid, amount: amount_for_teacher, credit_source: "SYSTEM", reason: "Issue Monthly Credits")
          if teacher_credit.save
            log_txn "    Saving Teacher credit for #{teacher.first_name} #{teacher.last_name} #{ teacher.id} teacher credit id #{teacher_credit.id}"
          else
            log_txn "    Unable to save teacher credit for #{teacher.first_name} #{teacher.last_name} #{ teacher.id}"
          end  
        end
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

  def pay_teacher(school, teacher, amount_for_teacher)
    log_txn "    Pay teacher #{teacher.first_name} #{teacher.last_name} #{ teacher.id} $#{ amount_for_teacher.to_s }"
    @credit_manager.monthly_credits_to_teacher school, teacher, amount_for_teacher
  end
  
  def log_txn(msg)
    begin
      @txnlog = File.open(@logfile, 'a'){ |f|
        f.write "#{Time.now.to_s}: #{msg}"
      }
    rescue
    end  
  end
end
