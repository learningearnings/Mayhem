module Reports
  module Processors
    class SignUpsReport
      attr_reader :filename, :options

      def initialize(options={})
        @options = options
        @filename = "sign_ups_report_#{Time.zone.now.strftime("%m_%d_%H_%M_%S")}.csv"
      end

      def run
        File.open("/tmp/" + filename, "w") {|f| f.write Reports::SignUpsReport.new(options).run }
        AdminMailer.delay.sign_ups_report(filename)
      end
    end
  end
end
