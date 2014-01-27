require 'csv'
require 'logger'
require 'forwardable'

class BuckUpdater
  attr_accessor :errors

  def initialize(file_path, amount, log_file_path='/tmp/le_importer.log')
    @amount = amount
    @file_path = file_path
    @log_file = File.open(log_file_path, 'a')
    @log_file_path = log_file_path
    @logger = Logger.new(@log_file)
  end

  def run
    buck_data.each do |datum|
      update_buck(datum)
    end
  end

  def buck_data
    parsed_doc.map do |buck|
      {
        buck: {
          code: buck["Code"]
        }
      }
    end
  end

  def update_buck(datum)
    if buck = OtuCode.find_by_code(datum[:buck][:code])
      buck.update_attributes(:points => BigDecimal.new(@amount))
    else
      @errors << "#{datum[:buck][:code]} not found"
    end
  end

  protected
  def parsed_doc
    CSV.parse(file_data, headers: true)
  end

  def file_data
    File.read(@file_path).gsub('\"', '""')
  end

end
