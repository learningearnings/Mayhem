class ReportExporter

  attr_accessor :csv

  def initialize(report)
    @report = report
    @report_data = JSON.parse(report.report_data)
    @keys = @report_data.first.keys.map{|x| x.titleize}
  end

  def export
    @csv = CSV.generate({}) do |csv|
      csv << @keys
      @report_data.each do |row|
        csv << row.values
      end
    end
  end

end
