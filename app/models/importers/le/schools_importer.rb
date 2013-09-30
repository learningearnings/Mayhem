require_relative './base_importer'

module Importers
  class Le
    class SchoolsImporter < BaseImporter
      protected
      def run
        school_data.each do |datum|
          find_or_create_school(datum)
        end
      end

      def school_data
        parsed_doc.map do |school|
          STDOUT.puts school.inspect
          {
             name: school["school"],
             legacy_school_id: school["SchoolID"],
             address1: school["schooladdress"],
             address2: school["schooladdress2"],
             city: school["city"],
             state_id: find_state(school['state']).id,
             zip: school["schoolzip"],
             school_phone: school["schoolphone"],
             min_grade: school["min_grade"],
             max_grade: school["max_grade"],
             distribution_model: school["distribution_model"]
          }
        end
      end

      def find_or_create_school(datum)
        existing_school(datum) || create_school(datum)
      end

      def existing_school(datum)
        School.where(legacy_school_id: datum[:legacy_school_id]).first
      end

      def find_state(state_name)
        # Christ, Connecticut is misspelled in this import data
        state_name = "Connecticut" if state_name == "Conneticut"
        State.find_by_name(state_name)
      end

      def create_school(datum)
        School.create(datum).tap do |school|
          school.activate!
        end
      end
    end
  end
end
