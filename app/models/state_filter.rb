class StateFilter < ActiveRecord::Base
  belongs_to :state
  belongs_to :filter

  attr_accessible :filter_id, :state_id

  validates_presence_of :filter_id
end
