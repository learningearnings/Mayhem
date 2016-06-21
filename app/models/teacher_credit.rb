class TeacherCredit < ActiveRecord::Base
  attr_accessible :amount, :credit_source, :district_guid, :school_id, :teacher_id, :teacher_name, :reason
  belongs_to :teacher
  belongs_to :school
  belongs_to :district, class_name: "District", foreign_key: "district_guid", primary_key: "guid"  
end
