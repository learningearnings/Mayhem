module Reports
  module Processors
    class SignUpsReport
      attr_reader :filename, :options, :email

      def initialize(options={})
        @options = options
        @email = options["to_email"]
        @filename = "sign_ups_report_#{Time.zone.now.strftime("%m_%d_%H_%M_%S")}.csv"
      end

      def run
        File.open("/tmp/" + filename, "w") {|f| f.write Reports::SignUpsReport.new(options).run }
        AdminMailer.sign_ups_report(filename,@email).deliver
      end
    end
  end
end
