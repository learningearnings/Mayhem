module JobLogger
  extend self

  def job_started
    @job = Job.create(type: self.class.name)
  end

  def job_ended
    @job.succeeded!
  end

  def job_failed_with_error(error)
    @job.failed_with_error!(error)
  end
end
