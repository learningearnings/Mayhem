class PersonClassFilterLink < ActiveRecord::Base
  belongs_to :filter, :inverse_of => :person_class_filter_links

  attr_accessible :filter_id, :person_class

#  validates_presence_of :filter_id

  validates_uniqueness_of :person_class, :scope => [:filter_id], :allow_nil => true, :unless => Proc.new { |f| f.filter_id.nil? }

end
