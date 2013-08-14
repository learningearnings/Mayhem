require 'csv'

module Importers
  class Le
    class BaseImporter
      attr_reader :file_path, :log_file_path
      def initialize(file_path, log_file_path='/tmp/le_importer.log')
        @file_path = file_path
        @log_file = File.open(log_file_path, 'a')
        @log_file_path = log_file_path
      end

      def call
        begin
          run
        ensure
          @log_file.close
        end
      end

      protected
      def parsed_doc
        CSV.parse(file_data, headers: true)
      end

      def file_data
        File.read(file_path).gsub('\"', '""')
      end

      def warn(msg)
        log "[WARN] #{msg}"
      end

      def log msg
        @log_file.puts msg
      end
    end
  end
end
