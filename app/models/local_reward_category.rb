class LocalRewardCategory < ActiveRecord::Base
  image_accessor :image
  attr_accessible :filter_id, :image_uid, :name
end
