class Job < ActiveRecord::Base
  self.inheritance_column = nil

  attr_accessible :type, :status, :details

  def succeeded!
    self.update_attributes({ status: "success" })
  end

  def failed_with_error!(error)
    self.update_attributes({ status: "failed", details: error })
    JobMailer.notify_of_failed_job(self)
  end
end
