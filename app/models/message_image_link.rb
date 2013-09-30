class MessageImageLink < ActiveRecord::Base

  attr_accessible :message_id, :message_image_id

  belongs_to :message
  belongs_to :message_image

end
