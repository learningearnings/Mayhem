module Reports
  module Processors
    class NewDistrictDashboardReport
      attr_reader :filename, :options

      def initialize(options={})
        @options = options
        @filename = "_#{Time.zone.now.strftime("%m_%d_%H_%M_%S")}.csv"
        @email_recipients = "" unless @options["email_recipients"]
        @email_recipients = @options["email_recipients"] if @options["email_recipients"]
      end

      def run
        File.open("/tmp/district_summary" + @filename, "w") {|f| f.write Reports::NewDistrictSummaryReport.new(options).run }
        #File.open("/tmp/teacher_credits" + @filename, "w") {|f| f.write Reports::NewTeacherCreditsReport.new(options).run }  
        #File.open("/tmp/student_logins" + @filename, "w") {|f| f.write Reports::NewStudentLoginsReport.new(options).run } 
        #File.open("/tmp/student_credits" + @filename, "w") {|f| f.write Reports::NewStudentCreditsReport.new(options).run }                     
        AdminMailer.delay.district_dashboard_report(filename, @email_recipients, @options)
      end
    end
  end
end
