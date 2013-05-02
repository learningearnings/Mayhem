class StateFilterLink < ActiveRecord::Base
  belongs_to :state
  belongs_to :filter, :inverse_of => :state_filter_links

  attr_accessible :filter_id, :state_id

#  validates_presence_of :filter_id

  validates_uniqueness_of :state_id, :scope => [:filter_id], :allow_nil => true, :unless => Proc.new { |f| f.filter_id.nil? }

end
