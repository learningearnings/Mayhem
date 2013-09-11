require_relative './base_importer'

module Importers
  class Le
    class TeacherPointsImporter < BaseImporter
      def run
        @credit_manager = CreditManager.new
        point_data.each do |datum|
          transfer_points(datum)
        end
      end

      def point_data
        parsed_doc.map do |point|
          {
            points: {
              legacy_user_id: point["TeacherID"],
              points: point["teacher_points"],
            }
          }
        end
      end

      def transfer_points(datum)
        begin
          teacher = Teacher.find_by_legacy_user_id(datum[:points][:legacy_user_id])
          @credit_manager.transfer_credits('Imported Legacy Points', @credit_manager.main_account, teacher.main_account(teacher.school.last), datum[:points][:points])
        rescue Exception => e
          warn "Got exception for #{datum.inspect} - #{e.inspect}"
        end
      end

    end
  end
end
