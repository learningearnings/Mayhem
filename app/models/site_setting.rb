class SiteSetting < ActiveRecord::Base

  attr_accessible :student_interest_rate, :interest_paid_at, as: :le_admin
  attr_accessible :student_interest_rate, :interest_paid_at

end
