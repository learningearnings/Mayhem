class MessageImage < ActiveRecord::Base
  image_accessor :image
  attr_accessible :image_uid

  has_many :messages, :through => :message_image_links
  has_many :message_image_links
end
