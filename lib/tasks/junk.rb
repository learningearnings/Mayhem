require 'powerschool-client'
require 'csv'
require 'json'
options = {}
options["url"]  = 'https://powerschool.hcde.org'
options["id"]  = '3058d3a6-2081-403e-8030-875e04cc22fb'
options["secret"] = '567044a7-23b0-45b4-987f-b2113366d3e2'
options["retries"] = 1
options["import_dir"] = '/srv/'
options['start_year'] = '2016'
options['schools'] = [1,21,62]
@district_guid = "903cd06f-623c-3909-a0e4-d503d57b8131"
psc = Powerschool::Client.new(options)
rows = psc.get_weekly_credits_no_absences
credit_manager = CreditManager.new
rows.each do | row |
  student = Student.where(district_guid: @district_guid, sti_id: row["dcid"]).first
  next unless student
  school = student.school
  next unless school
  next unless school.weekly_perfect_attendance_amount
  amount = school.weekly_perfect_attendance_amount 
  ActionController::Base.new.expire_fragment "#{student.id}_balances"
  otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
    :student_id => student.id,
    :ebuck => true,
    :points => BigDecimal.new(amount))
  otu_code.mark_redeemed!
  credit_manager.issue_weekly_automatic_credits_to_student("Weekly Credits for PS Perfect Attendance", school, student, amount, otu_code)         
end

options = {}
options["url"]  = 'https://powerschool.hcde.org'
options["id"]  = '3058d3a6-2081-403e-8030-875e04cc22fb'
options["secret"] = '567044a7-23b0-45b4-987f-b2113366d3e2'
options["retries"] = 1
options["import_dir"] = '/srv/'
options['start_year'] = '2016'
options['schools'] = [1,21,62]
@district_guid = "903cd06f-623c-3909-a0e4-d503d57b8131"
psc = Powerschool::Client.new(options)
rows = psc.get_weekly_credits_no_tardies
credit_manager = CreditManager.new
rows.each do | row |
         student = Student.where(district_guid: @district_guid, sti_id: row["dcid"]).first
         next unless student
         school = student.school
         next unless school
         next unless school.weekly_no_tardies_amount
         amount = school.weekly_no_tardies_amount 
        ActionController::Base.new.expire_fragment "#{student.id}_balances"
        otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
          :student_id => student.id,
          :ebuck => true,
          :points => BigDecimal.new(amount))
        otu_code.mark_redeemed!
        credit_manager.issue_weekly_automatic_credits_to_student("Weekly Credits for PS No Tardies", school, student, amount, otu_code) 
end
options = {}
options["url"]  = 'https://powerschool.hcde.org'
options["id"]  = '3058d3a6-2081-403e-8030-875e04cc22fb'
options["secret"] = '567044a7-23b0-45b4-987f-b2113366d3e2'
options["retries"] = 1
options["import_dir"] = '/srv/'
options['start_year'] = '2016'
options['schools'] = [1,21,62]
@district_guid = "903cd06f-623c-3909-a0e4-d503d57b8131"
psc = Powerschool::Client.new(options)
rows = psc.get_weekly_credits_no_infractions
credit_manager = CreditManager.new
rows.each do | row |
         student = Student.where(district_guid: @district_guid, sti_id: row["dcid"]).first
         next unless student
         school = student.school
         next unless school
         next unless school.weekly_no_infractions_amount
         amount = school.weekly_no_infractions_amount 
        ActionController::Base.new.expire_fragment "#{student.id}_balances"
        otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
          :student_id => student.id,
          :ebuck => true,
          :points => BigDecimal.new(amount))
        otu_code.mark_redeemed!
        credit_manager.issue_weekly_automatic_credits_to_student("Weekly Credits for PS No Infractions", school, student, amount, otu_code)             
end

