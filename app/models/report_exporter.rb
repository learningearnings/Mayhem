class ReportExporter

  attr_accessor :csv

  def initialize(report)
    @report = report
    @report_data = JSON.parse(report.report_data)
    @keys = @report_data.first.keys.map{|x| x.titleize}
  end

  def export
    old_csv = CSV.generate({}) do |csv|
      csv << @keys
      @report_data.each do |row|
        csv << row.values
      end
    end
    original = CSV.parse(old_csv, { headers: true, return_headers: true })
    original.delete('Delivery Teacher')
    original.delete('Delivery Status')
    @csv = CSV.generate({}) do |csv|
      original.each do |row|
        csv << row
      end
    end
  end

end
