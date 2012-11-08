class UploadedUser < ActiveRecord::Base
  attr_accessible :approved_by_id, :batch_name, :created_by_id, :email, :first_name, :grade, :last_name, :message, :password, :person_id, :school_id, :state, :type, :username
  belongs_to :created_by_person, :foreign_key => :created_by_id, :class_name => "Person"
  belongs_to :approved_by_person, :foreign_key => :approved_by_id, :class_name => "Person"
  belongs_to :school
  belongs_to :person
end
