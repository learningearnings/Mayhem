require 'csv'
require 'logger'
require 'forwardable'
require 'spreadsheet'

class BaseImporter
  extend Forwardable
  def_delegators :@logger, :warn, :info, :debug

  attr_reader :school_id, :file, :log_file_path
  def initialize(school_id, file, log_file_path='/tmp/le_importer.log')
    return false unless file
    if file.original_filename.include?('.xlsx')
      new_file = store_xlsx_file(file)
      @file = convert_xlsx(new_file.path)
    elsif file.original_filename.include?('.xls')
      path = file_path(file)
      new_file = store_file(file)
      book = Spreadsheet.open(new_file.path)
      new_path = book.write("/tmp/#{file.original_filename}.xls")
      @file = convert("/tmp/#{file.original_filename}.xls")
    elsif file.original_filename.include?('.csv')
      @file = file.read
    end

    @log_file = File.open(log_file_path, 'a')
    @log_file_path = log_file_path
    @logger = Logger.new(@log_file)
    @school = School.find(school_id)
  end

  def convert(path)
    Roo::Excel.new(path).to_csv
  end

  def convert_xlsx(path)
    Roo::Excelx.new(path).to_csv
  end

  def call
    begin
      run
    ensure
      @log_file.try(:close)
    end
  end

  protected
  def parsed_doc
    CSV.parse(@file, headers: true)
  end

  def store_file(file)
    File.open(file_path(file), "w:ASCII-8BIT"){ |f| f << file.read }
  end

  def file_path(file)
    file.tempfile.path + ".xls"
  end

  def store_xlsx_file(file)
    File.open(xlsx_file_path(file), "w:ASCII-8BIT"){ |f| f << file.read }
  end

  def xlsx_file_path(file)
    file.tempfile.path + ".xlsx"
  end
end
