class StudentUpdaterWorker
  include Sidekiq::Worker

  def perform(students, school_id, action, delayed_report_id, current_person)
    delayed_report = DelayedReport.find(delayed_report_id)
    delayed_report.process
    if action == 'delete!'
      BatchStudentUpdater.new(students, school_id,current_person).delete!
    else
      BatchStudentUpdater.new(students, school_id,current_person).call
    end
    delayed_report.report_data = delayed_report.instance_variable_get("@data").to_json
    delayed_report.complete
  end

end
