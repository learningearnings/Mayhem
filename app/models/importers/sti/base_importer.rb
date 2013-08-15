require 'nokogiri'

module Importers
  class Sti
    class BaseImporter
      attr_reader :file_path
      def initialize(file_path)
        @file_path = file_path
      end

      def call
        raise "NYI"
      end

      protected
      def parsed_doc
        Nokogiri::XML(file_data)
      end

      def file_data
        File.read(file_path)
      end
    end
  end
end
