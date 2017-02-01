namespace :missing_teacher_credits do
  desc "Generate missing teacher credits for the generated school credit record."
  task :generate_missing_credits => :environment do
    #### Assign Date over here
    created_date = "2017-02-01 00:00:00.000000"
    schools = School.joins(:school_credits).where("school_credits.created_at >= ?", created_date)
    schools.each do |school|
      if school.teacher_credits.where("created_at >= ?", created_date).count == 0
        
        teachers_to_pay(school, { hide_ignored: false }).each do |teacher|
          if revoke_remainder(school, teacher, teacher.main_account(school).balance)
            teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: school.id, teacher_name: teacher.name, district_guid: school.district_guid, amount: teacher.main_account(school).balance, credit_source: "SYSTEM", reason: "Reset monthly balance")
            teacher_credit.save
          end
        end
        teachers_to_pay(school, { hide_ignored: true }).each do |teacher|
          amount_for_teacher = amount_for_teacher(school)
          if pay_teacher(school, teacher,amount_for_teacher)
            teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: school.id, teacher_name: teacher.name, district_guid: school.district_guid, amount: amount_for_teacher, credit_source: "SYSTEM", reason: "Issue Monthly Credits")
            teacher_credit.save
          end
        end
        school_credit = school.school_credits.where("created_at >= ?", created_date).last
        teachers_paid = (teachers_to_pay(school, { hide_ignored: false }) + teachers_to_pay(school, { hide_ignored: true })).uniq
        school_credit.total_teachers = teachers_paid.count
        school_credit.save
      end
    end


end
end
# 25 dollars per student per day
def amount_for_school school
  daily_stydent_amount = 25

  days_in_month = Time.days_in_month(Time.now.month)
  days_left_in_month = (days_in_month - 1) + 1

  if school.district_guid
    amount_school = daily_stydent_amount * days_left_in_month * school.students.count
  else
    amount_school = daily_stydent_amount * days_left_in_month * active_students(school).count
  end
  amount_school = amount_school * ((school.admin_credit_percent.to_f/100)+1)
end

def revoke_remainder(school, teacher, amount)
  CreditManager.new.revoke_credits_for_teacher(school, teacher, amount)
end

def amount_for_teacher(school)
  amount_for_school(school) / teachers_to_pay(school, { hide_ignored: true }).count
end

def teachers_to_pay(school, options={})
  if school.district_guid or (school.credits_type == "child")
    teachers = school.teachers.joins(:person_school_links).where(person_school_links: { school_id: school.id, can_distribute_credits: true }).uniq
    options[:hide_ignored] ? teachers.not_ignored(school.id) : teachers
  else
    (school.teachers.recently_logged_in + school.teachers.recently_created).uniq
  end
end

def active_students(school)
  (school.students.recently_logged_in + school.students.recently_created).uniq
end

def pay_teacher(school, teacher, amount_for_teacher)
  CreditManager.new.monthly_credits_to_teacher school, teacher, amount_for_teacher
end    
