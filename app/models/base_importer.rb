require 'csv'
require 'logger'
require 'forwardable'

class BaseImporter
  extend Forwardable
  def_delegators :@logger, :warn, :info, :debug

  attr_reader :school_id, :file, :log_file_path
  def initialize(school_id, file, log_file_path='/tmp/le_importer.log')
    if file.original_filename.include?('.xls')
      path = file_path(file)
      #file = store_file(file)
      @file = convert(path)
      binding.pry
    elsif file.original_filename.include?('.csv')
      @file = file.read
    end

    @log_file = File.open(log_file_path, 'a')
    @log_file_path = log_file_path
    @logger = Logger.new(@log_file)
    @school = School.find(school_id)
  end

  def convert(file)
    Roo::Excel.new(file).to_csv
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
    File.read(@file).gsub('\"', '""')
  end

  def store_file(file)
    File.open(file_path(file), "w:ASCII-8BIT"){ |f| f << file.read }
  end

  def file_path(file)
    file.tempfile.path + ".xls"
  end
end
