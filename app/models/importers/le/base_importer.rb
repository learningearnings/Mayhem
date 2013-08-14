require 'csv'

module Importers
  class Le
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
        CSV.parse(file_data, headers: true)
      end

      def file_data
        File.read(file_path)
      end

      def warn(msg)
        STDOUT.puts msg
      end
    end
  end
end
