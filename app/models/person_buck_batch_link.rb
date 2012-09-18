class PersonBuckBatchLink < ActiveRecord::Base

  attr_accessible :person_id, :buck_batch_id
  belongs_to :person
  belongs_to :buck_batch

end
