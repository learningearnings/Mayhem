class DelayedReportWorker
  include Sidekiq::Worker

  def perform report, delayed_report_id
    report = Marshal.load(report)
    delayed_report = DelayedReport.find(delayed_report_id)
    delayed_report.process!
    report.execute!
    delayed_report.report_data = report.instance_variable_get("@data").to_json
    delayed_report.complete!
  end
end
