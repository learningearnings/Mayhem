module Reports
  module Processors
    class NewUserActivityDetailReport
      attr_reader :filename, :options

      def initialize(options={})
        @options = options
        @filename = "_#{Time.zone.now.strftime("%m_%d_%H_%M_%S")}.csv"
        @email_recipients = "" unless @options["email_recipients"]
        @email_recipients = @options["email_recipients"] if @options["email_recipients"]
      end

      def run
        File.open("/tmp/teacher_logins" + @filename, "w") {|f| f.write Reports::NewTeacherLoginsReport.new(options).run }
        File.open("/tmp/teacher_credits" + @filename, "w") {|f| f.write Reports::NewTeacherCreditsReport.new(options).run }  
        File.open("/tmp/student_logins" + @filename, "w") {|f| f.write Reports::NewStudentLoginsReport.new(options).run } 
        File.open("/tmp/student_credits" + @filename, "w") {|f| f.write Reports::NewStudentCreditsReport.new(options).run }                     
        AdminMailer.user_activity_detail_report(filename, @email_recipients).deliver
      end
    end
  end
end
