class MessageCodeLink < ActiveRecord::Base

  attr_accessible :message_id, :otu_code_id
  belongs_to :message
  belongs_to :otu_code
end
