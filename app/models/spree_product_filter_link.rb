class SpreeProductFilterLink < ActiveRecord::Base
  attr_accessible :filter_id, :product_id, :filter, :product

  belongs_to :product, :class_name => Spree::Product
  belongs_to :filter

  validates :filter_id, :presence => true, :numericality => true
  validates :product_id, :presence => true, :numericality => true, :uniqueness => true

  ## TODO check to see if these are needed
  #More validations - exists in table
  validates :filter, :presence => true
  validates :product, :presence => true

  has_many :filter_classrooms, :through => :filter
  has_many :filter_states, :through => :filter
  has_many :filter_schools, :through => :filter
  has_many :classrooms, :through => :filter_classrooms
  has_many :states, :through => :filter_states
  has_many :schools, :through => :filter_schools

end
