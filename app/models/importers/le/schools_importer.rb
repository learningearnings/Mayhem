require_relative './base_importer'

module Importers
  class Le
    class SchoolsImporter < BaseImporter
      def call
        school_data.each do |datum|
          find_or_create_school(datum)
        end
      end

      protected
      def school_data
        parsed_doc.map do |school|
          {
             name: school["school"],
             legacy_school_id: school["SchoolID"],
             address1: school["schooladdress"],
             address2: school["schooladdress2"],
             city: school["city"],
             state: State.find_by_name(school["state"]),
             zip: school["schoolzip"],
             min_grade: school["min_grade"],
             max_grade: school["max_grade"],
             distribution_model: school["distribution_model"]
          }
        end
      end

      def find_or_create_school(datum)
        existing_school(datum) || School.create(datum)
      end

      def existing_school(datum)
        School.where(legacy_school_id: datum[:legacy_school_id]).first
      end
    end
  end
end
