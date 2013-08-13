require_relative './base_importer'
module Importers
  class Sti
    class SchoolsImporter < BaseImporter
      def call
        school_data.each do |datum|
          find_or_create_school(datum)
        end
      end

      protected
      def school_data
        parsed_doc.xpath("//Schools/School").map do |school|
          {
             name: school["Name"],
             sti_uuid: school["Guid"],
             address1: school["AddressLine1"],
             address2: school["AddressLine2"],
             city: school["City"],
             state: State.find_by_abbr(school["State"]),
             zip: school["PostalCode"]
          }
        end
      end

      def find_or_create_school(datum)
        existing_school(datum) || School.create(datum)
      end

      def existing_school(datum)
        School.where(sti_uuid: datum[:sti_uuid]).first
      end
    end
  end
end
