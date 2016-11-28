module Reports
  module Processors
    class ALSDEStudy
      attr_reader :options

      def initialize(options={})
        @options = options
        @staff_filename = "alsde_study_staff_#{Time.zone.now.strftime("%m_%d")}.csv"
        @student_filename = "alsde_study_students_#{Time.zone.now.strftime("%m_%d")}.csv"
      end

      def run
        File.open("/tmp/" + @staff_filename, "w") {|f| f.write Reports::ALSDEStudy::StaffReport.new(options).run }
        File.open("/tmp/" + @student_filename, "w") {|f| f.write Reports::ALSDEStudy::StudentsReport.new(options).run }
        AdminMailer.delay.alsde_study_report(@staff_filename, @student_filename)
      end
    end
  end
end
