class UploadedUser < ActiveRecord::Base
  attr_accessible :approved_by_id, :batch_id, :created_by_id, :email, :first_name, :grade, :last_name, :message, :password, :person_id, :school_id, :state, :type, :username
end
