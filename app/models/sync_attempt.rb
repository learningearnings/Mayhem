class SyncAttempt < ActiveRecord::Base
  attr_accessible :district_guid, :status, :sync_type, :students_response, :staff_response, :sections_response, :rosters_response, :schools_response, :staff_version, :student_version, :section_version, :roster_version
end
