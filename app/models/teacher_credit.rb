class TeacherCredit < ActiveRecord::Base
  attr_accessible :amount, :credit_source, :district_guid, :school_id, :teacher_id, :teacher_name, :reason
  belongs_to :teacher
  belongs_to :school
  belongs_to :district, class_name: "District", foreign_key: "district_guid", primary_key: "guid" 
  scope :credits_created_at, lambda {|start_date, end_date| where("created_at >= ? AND created_at <= ?", start_date, end_date) }
end
