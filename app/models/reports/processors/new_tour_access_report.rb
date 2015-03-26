module Reports
  module Processors
    class NewTourAccessReport
      attr_reader :filename, :options, :email

      def initialize(options={})
        @options = options
        @email = options[:to_email]        
        @filename = "tour_access_report_#{Time.zone.now.strftime("%m_%d_%H_%M_%S")}.csv"
      end

      def run
        File.open("/tmp/" + filename, "w") {|f| f.write Reports::NewTourAccessReport.new(options).run }
        AdminMailer.tour_access_report(filename, @email).deliver
      end
    end
  end
end
