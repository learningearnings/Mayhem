require 'readline'
require 'powerschool-client'

ARRAY_OF_PS_POWERSCHOOL_CRITERIAS = [
  {
    ps_client_method_name: 'get_weekly_credits_no_absences',
    school_method_name: 'weekly_perfect_attendance_amount',
    message_string: 'PS Perfect Attendance'
  },
  {
    ps_client_method_name: 'get_weekly_credits_no_tardies',
    school_method_name: 'weekly_no_tardies_amount',
    message_string: 'PS No Tardies'
  },
  {
    ps_client_method_name: 'get_weekly_credits_no_infractions',
    school_method_name: 'weekly_no_infractions_amount',
    message_string: 'PS No Infractions'
  }
]

namespace :le do
  desc "User Activity Report"
  task :user_activity_report => :environment do
    Reports::Processors::NewUserActivityReport.new.run
  end

  desc "Teacher Activity Report"
  task :teacher_activity_report => :environment do
    filename = "teacher_activity_report_#{Time.zone.now.strftime("%m_%d")}.csv"
    File.open("/tmp/" + filename, "w") {|f| f.write Reports::TeacherActivityReport.new.run}
    AdminMailer.teacher_activity_report(filename).deliver
  end

  desc "STI Nightly Import"
  task :sti_nightly_import => :environment do
    StiLinkToken.where(status: 'active').order(:status).each do |link_token|
      if link_token.username == "PowerSchool"
        PSImporterWorker.setup_sync(link_token.district_guid)
      else
        StiImporterWorker.setup_sync(link_token.api_url, link_token.username, link_token.password, link_token.district_guid)
      end
 
    end
  end

  desc "Award weekly automatic credits"
  task :award_weekly_automatic_credits => :environment do
    School.inow_schools.has_weekly_automatic_credit_amounts.each do |school|
      begin
        start_date = Time.zone.now.beginning_of_week.strftime("%Y-%m-%d")
        end_date = Time.zone.now.end_of_week.strftime("%Y-%m-%d")
        credit_manager = CreditManager.new
        sti_link_token = StiLinkToken.where(district_guid: school.district_guid, status: 'active').order(:status).first
        next unless sti_link_token
        sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
        if school.weekly_perfect_attendance_amount.present?
          sti_ids = sti_client.perfect_attendance(school.sti_id, start_date, end_date)
          students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
          students.each do |student|
            ActionController::Base.new.expire_fragment "#{student.id}_balances"
            otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
              :student_id => student.id,
              :ebuck => true,
              :points => BigDecimal.new(school.weekly_perfect_attendance_amount))
            otu_code.mark_redeemed!
            credit_manager.issue_weekly_automatic_credits_to_student("Weekly Credits for Perfect Attendance", school, student, school.weekly_perfect_attendance_amount, otu_code)
          end
        end

        if school.weekly_no_tardies_amount.present?
          sti_ids = sti_client.no_tardies(school.sti_id, start_date, end_date)
          students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
          students.each do |student|
            ActionController::Base.new.expire_fragment "#{student.id}_balances"
            otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
                   :student_id => student.id,
                   :ebuck => true,
                   :points => BigDecimal.new(school.weekly_no_tardies_amount))
            otu_code.mark_redeemed!
            credit_manager.issue_weekly_automatic_credits_to_student("Weekly Credits for No Tardies", school, student, school.weekly_no_tardies_amount, otu_code)
          end
        end

        if school.weekly_no_infractions_amount.present?
          sti_ids = sti_client.no_infractions(school.sti_id, start_date, end_date)
          students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
          students.each do |student|
            ActionController::Base.new.expire_fragment "#{student.id}_balances"
            otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
                   :student_id => student.id,
                   :ebuck => true,
                   :points => BigDecimal.new(school.weekly_no_infractions_amount))
            otu_code.mark_redeemed!            
            credit_manager.issue_weekly_automatic_credits_to_student("Weekly Credits for No Infractions", school, student, school.weekly_no_infractions_amount, otu_code)
          end
        end
      rescue => e
        puts "Issue with weekly credits for school: #{school.id}"
        puts "Here's the error: #{e}"
        next
      end
    end
  end

  desc 'Award weekly automatic credits for Powerschool'
  task award_weekly_automatic_credits_powerschool: :environment do
    ARRAY_OF_PS_POWERSCHOOL_CRITERIAS.each do |criteria|
      options = {
        url: 'https://powerschool.hcde.org',
        id: '3058d3a6-2081-403e-8030-875e04cc22fb',
        secret: '567044a7-23b0-45b4-987f-b2113366d3e2',
        retires: 1,
        import_dir: '/srv/',
        start_year: '2016',
        schools: [1, 21, 62]
      }.stringify_keys!
      district_guid = '903cd06f-623c-3909-a0e4-d503d57b8131'
      psc = Powerschool::Client.new(options)
      rows = psc.send(criteria[:ps_client_method_name])
      credit_manager = CreditManager.new
      rows.each do | row |
        student = Student.where(district_guid: district_guid, sti_id: row['dcid']).first
        next unless student
        school = student.school
        next unless school
        next unless school.send(criteria[:school_method_name])
        amount = school.send(criteria[:school_method_name])
        ActionController::Base.new.expire_fragment "#{student.id}_balances"
        otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
          :student_id => student.id,
          :ebuck => true,
          :points => BigDecimal.new(amount))
        otu_code.mark_redeemed!
        credit_manager.issue_weekly_automatic_credits_to_student("Weekly Credits for #{criteria[:message_string]}", school, student, amount, otu_code)
      end
    end
  end

  # Note that this runs the previous month, because it is much easier to setup a cron job to run
  # at the first of the month, than the end of the month, because months have different numbers
  # of days and you have to also take into account leap year.
  desc "Award monthly automatic credits"
  task :award_monthly_automatic_credits => :environment do
    School.inow_schools.has_monthly_automatic_credit_amounts.each do |school|
      start_date = 1.month.ago.beginning_of_month.strftime("%Y-%m-%d")
      end_date = 1.month.ago.end_of_month.strftime("%Y-%m-%d")
      credit_manager = CreditManager.new
      sti_link_token = StiLinkToken.where(district_guid: school.district_guid, status: 'active').order(:status).first
      next unless sti_link_token
      sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
      if school.monthly_perfect_attendance_amount.present?
        sti_ids = sti_client.perfect_attendance(school.sti_id, start_date, end_date)
        students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
        students.each do |student|
          ActionController::Base.new.expire_fragment "#{student.id}_balances"
          otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
                 :student_id => student.id,
                 :ebuck => true,
                 :points => BigDecimal.new(school.monthly_perfect_attendance_amount))
          otu_code.mark_redeemed! 
          credit_manager.issue_monthly_automatic_credits_to_student("Monthly Credits for Perfect Attendance", school, student, school.monthly_perfect_attendance_amount,otu_code)
        end
      end

      if school.monthly_no_tardies_amount.present?
        sti_ids = sti_client.no_tardies(school.sti_id, start_date, end_date)
        students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
        students.each do |student|
          ActionController::Base.new.expire_fragment "#{student.id}_balances"
          otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
                 :student_id => student.id,
                 :ebuck => true,
                 :points => BigDecimal.new(school.monthly_no_tardies_amount))
          otu_code.mark_redeemed!          
          credit_manager.issue_monthly_automatic_credits_to_student("Monthly Credits for No Tardies", school, student, school.monthly_no_tardies_amount, otu_code)
        end
      end

      if school.monthly_no_infractions_amount.present?
        sti_ids = sti_client.no_infractions(school.sti_id, start_date, end_date)
        students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
        students.each do |student|
          ActionController::Base.new.expire_fragment "#{student.id}_balances"
          otu_code = OtuCode.create(:expires_at => (Time.now + 90.days),
                 :student_id => student.id,
                 :ebuck => true,
                 :points => BigDecimal.new(school.monthly_no_infractions_amount))
          otu_code.mark_redeemed!  
          credit_manager.issue_monthly_automatic_credits_to_student("Monthly Credits for No Infractions", school, student, school.monthly_no_infractions_amount, otu_code)
        end
      end
    end
  end
end