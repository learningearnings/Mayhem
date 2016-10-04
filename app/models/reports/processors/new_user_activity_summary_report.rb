module Reports
  module Processors
    class NewUserActivitySummaryReport
      attr_reader :filename, :options

      def initialize(options={})
        @options = options
        @filename = "user_activity_summary_#{Time.zone.now.strftime("%m_%d_%H_%M_%S")}.csv"
        @email_recipients = "" unless @options["email_recipients"]
        @email_recipients = @options["email_recipients"] if @options["email_recipients"]
      end

      def run
        File.open("/tmp/" + @filename, "w") {|f| f.write Reports::NewUserActivitySummaryReport.new(options).run }
        AdminMailer.delay.user_activity_summary_report(filename, @email_recipients)
      end
    end
  end
end
