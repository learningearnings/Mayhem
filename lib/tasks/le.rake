require 'readline'

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
    StiLinkToken.where(status: 'active').each do |link_token|
      StiImporterWorker.setup_sync(link_token.api_url, link_token.username, link_token.password, link_token.district_guid)
    end
  end

  desc "Award weekly automatic credits"
  task :award_weekly_automatic_credits => :environment do
    School.inow_schools.has_weekly_automatic_credit_amounts.pluck(:id).each do |school_id|
      Jobs::Weekly::AwardAutomaticCredits.new(school_id).run
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
      sti_link_token = StiLinkToken.where(district_guid: school.district_guid, status: 'active').first
      next unless sti_link_token
      sti_client = STI::Client.new :base_url => sti_link_token.api_url, :username => sti_link_token.username, :password => sti_link_token.password
      if school.monthly_perfect_attendance_amount.present?
        sti_ids = sti_client.perfect_attendance(school.sti_id, start_date, end_date)
        students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
        students.each do |student|
          ActionController::Base.new.expire_fragment "#{student.id}_balances"
          credit_manager.issue_monthly_automatic_credits_to_student("Monthly Credits for Perfect Attendance", school, student, school.monthly_perfect_attendance_amount)
        end
      end

      if school.monthly_no_tardies_amount.present?
        sti_ids = sti_client.no_tardies(school.sti_id, start_date, end_date)
        students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
        students.each do |student|
          ActionController::Base.new.expire_fragment "#{student.id}_balances"
          credit_manager.issue_monthly_automatic_credits_to_student("Monthly Credits for No Tardies", school, student, school.monthly_no_tardies_amount)
        end
      end

      if school.monthly_no_infractions_amount.present?
        sti_ids = sti_client.no_infractions(school.sti_id, start_date, end_date)
        students = Student.where(district_guid: school.district_guid, sti_id: sti_ids)
        students.each do |student|
          ActionController::Base.new.expire_fragment "#{student.id}_balances"
          credit_manager.issue_monthly_automatic_credits_to_student("Monthly Credits for No Infractions", school, student, school.monthly_no_infractions_amount)
        end
      end
    end
  end
end
