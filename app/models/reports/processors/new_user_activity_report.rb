module Reports
  module Processors
    class NewUserActivityReport
      attr_reader :filename, :options, :email

      def initialize(options={})
        @options = options
        @email = options["to_email"]     
        @filename = "user_activity_report_#{Time.zone.now.strftime("%m_%d")}.csv"
      end

      def run
        File.open("/tmp/" + filename, "w") {|f| f.write Reports::NewUserActivityReport.new(options).run }
        AdminMailer.user_activity_report(filename, @email).deliver
      end
    end
  end
end
