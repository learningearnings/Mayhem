class DelayedReportWorker
  include Sidekiq::Worker

  def perform report, delayed_report_id
    logger.warn("AKT DelayedReportWorker")
    report = Marshal.load(report)
    logger.warn("AKT report: #{report.inspect}")
    delayed_report = DelayedReport.find(delayed_report_id)
    logger.warn("AKT DelayedReportWorker process")
    delayed_report.process!
    logger.warn("AKT DelayedReportWorker execute")
    report.execute!
    logger.warn("AKT DelayedReportWorker data")
    delayed_report.report_data = report.instance_variable_get("@data").to_json
    delayed_report.complete!
  end
end
