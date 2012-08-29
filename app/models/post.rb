class Post < ActiveRecord::Base
  attr_accessible :body, :filter_id, :person_id, :published_by, :status, :title, :type
  belongs_to :person
end
