class SchoolCredit < ActiveRecord::Base
  attr_accessible :district_guid, :school_id, :school_name, :total_teachers, :amount
  belongs_to :school
  belongs_to :district, class_name: "District", foreign_key: "district_guid", primary_key: "guid"  
end
