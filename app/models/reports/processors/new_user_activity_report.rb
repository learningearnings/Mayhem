module Reports
  module Processors
    class NewUserActivityReport
      attr_reader :filename, :options

      def initialize(options={})
        @options = options
        @filename = "user_activity_report_#{Time.zone.now.strftime("%m_%d")}.csv"
      end

      def run
        File.open("/tmp/" + filename, "w") {|f| f.write Reports::NewUserActivityReport.new(options).run }
        AdminMailer.delay.user_activity_report(filename)
      end
    end
  end
end
