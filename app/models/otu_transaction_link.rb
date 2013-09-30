class OtuTransactionLink < ActiveRecord::Base

  belongs_to :transactions
  belongs_to :otu_codes

end
