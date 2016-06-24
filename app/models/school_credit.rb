class SchoolCredit < ActiveRecord::Base
  attr_accessible :district_guid, :school_id, :school_name, :total_teachers, :amount
  belongs_to :school
  belongs_to :district, class_name: "District", foreign_key: "district_guid", primary_key: "guid"
  scope :credits_created_at, lambda {|start_date, end_date| where("created_at >= ? AND created_at <= ?", start_date, end_date) }
  
end
