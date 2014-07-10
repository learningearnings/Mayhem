class ParentStudentLink < ActiveRecord::Base
  attr_accessible :parent_id, :status, :student_id
  belongs_to :parent
  belongs_to :student
end
