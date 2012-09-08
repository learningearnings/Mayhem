class BuckBatchLink < ActiveRecord::Base

  attr_accessible :otu_code_id, :buck_batch_id

  belongs_to :otu_code
  belongs_to :buck_batch

end
