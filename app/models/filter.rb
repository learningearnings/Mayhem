class Filter < ActiveRecord::Base
  attr_accessible :maximum_grade, :minimum_grade, :nickname
  has_many :school_filter_links, :inverse_of => :filter, :autosave => true
  has_many :classroom_filter_links, :inverse_of => :filter, :autosave => true
  has_many :state_filter_links, :inverse_of => :filter, :autosave => true
  has_many :person_class_filter_links, :inverse_of => :filter, :autosave => true

  has_many :schools, :through => :school_filter_links, :inverse_of => :school_filter_links
  has_many :classrooms, :through => :classroom_filter_links, :inverse_of => :classroom_filter_links
  has_many :states, :through => :state_filter_links, :inverse_of => :state_filter_links

  has_many :spree_product_filter_links
  has_many :products, :through => :spree_product_filter_links

#  accepts_nested_attributes_for :school_filter_links, :classroom_filter_links, :state_filter_links, :person_class_filter_links

  validates_presence_of :minimum_grade, :maximum_grade

  def person_classes
    person_class_filter_links.collect do |pcfl|
      pcfl.person_class
    end
  end

  def to_s
    s = schools.collect do |s|
      "#{s.id.to_s} - #{s.name}"
    end
    c = classrooms.collect do |c|
      "#{c.id.to_s} - #{c.name}"
    end
    st = states.collect do |s|
      "#{s.id.to_s} - #{s.name}"
    end
    "id = #{self.id}," +
      "state_filter_links = #{state_filter_links.to_s}" +
      "school_filter_links = #{school_filter_links.to_s}" +
      "classroom_filter_links = #{classroom_filter_links.to_s}" +
      "person_class_filter_links = #{person_class_filter_links.to_s}" +
      "states = #{st}" +
      "schools = #{s}" +
      "classrooms = #{c}"
  end



end
