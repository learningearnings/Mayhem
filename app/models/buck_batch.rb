class BuckBatch < ActiveRecord::Base

  attr_accessible :name
  has_many :otu_codes, :through => :buck_batch_links
  has_many :buck_batch_links

end
