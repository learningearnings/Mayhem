require 'nokogiri'

module Importers
  class Sti
    class SchoolsImporter
      attr_reader :file_path
      def initialize(file_path)
        @file_path = file_path
      end

      def call
        school_data.each do |datum|
          School.create(datum)
        end
      end

      protected
      def parsed_doc
        Nokogiri::XML(file_data)
      end

      def file_data
        File.read(file_path)
      end

      def school_data
        parsed_doc.xpath("//Schools/School").map do |school|
          {
             name: school.attributes["Name"].value,
             sti_uuid: school.attributes["Guid"].value,
             address1: school.attributes["AddressLine1"].value,
             address2: school.attributes["AddressLine2"].value,
             city: school.attributes["City"].value,
             state: State.find_by_abbr(school.attributes["State"].value),
             zip: school.attributes["PostalCode"].value
          }
        end
      end
    end
  end
end
