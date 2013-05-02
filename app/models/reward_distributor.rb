class RewardDistributor < ActiveRecord::Base
  attr_accessible :person_school_link_id

  belongs_to :person_school_link
  has_one :teacher, :through => :person_school_link, :source => :person
  has_one :school, :through => :person_school_link


end
