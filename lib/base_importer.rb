require 'csv'
require 'logger'
require 'forwardable'

class BaseImporter
  extend Forwardable
  def_delegators :@logger, :warn, :info, :debug

  attr_reader :school_id, :file_path, :log_file_path
  def initialize(school_id, file_path, log_file_path='/tmp/le_importer.log')
    if file_path.include?('.xls')
      @file_path = convert(file_path)
    elsif file_path.include?('.csv')
      @file_path = file_path
    end
    @log_file = File.open(log_file_path, 'a')
    @log_file_path = log_file_path
    @logger = Logger.new(@log_file)
    @school = School.find(school_id)
  end
  
  def convert(file_path)
    begin
      file_basename = File.basename(file_path, ".xls")
      xls = Roo::Excel.new(file_path)
      xls.to_csv("/tmp/#{file_basename}.csv")
      file_path = "/tmp/#{file_basename}.csv"
    end
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
end
