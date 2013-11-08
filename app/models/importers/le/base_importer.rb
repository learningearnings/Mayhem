require 'csv'
require 'logger'
require 'forwardable'

module Importers
  class Le
    class BaseImporter
      extend Forwardable
      def_delegators :@logger, :warn, :info, :debug

      attr_reader :file_path, :log_file_path
      def initialize(file_path, log_file_path='/tmp/le_importer.log')
        @file_path = file_path
        @log_file = File.open(log_file_path, 'a')
        @log_file_path = log_file_path
        @logger = Logger.new(@log_file)
      end

      def call
        begin
          #ActiveRecord::Base.transaction do
            run
          #end
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
    end
  end
end
