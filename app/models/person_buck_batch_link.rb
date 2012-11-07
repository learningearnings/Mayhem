class PersonBuckBatchLink < ActiveRecord::Base

  attr_accessible :person_school_link_id, :buck_batch_id
  belongs_to :person_school_link
  has_one :person, :through => :person_school_links
  belongs_to :buck_batch

end
