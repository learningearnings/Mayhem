class PersonClassFilter < ActiveRecord::Base
  belongs_to :filter

  attr_accessible :filter_id, :person_class

  validates_presence_of :filter_id


end
