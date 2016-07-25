class Parent < Person
	belongs_to :student
	accepts_nested_attributes_for :user
  attr_accessible :user_attributes
  
  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end
end
