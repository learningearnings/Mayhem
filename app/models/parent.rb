class Parent < Person
	belongs_to :student
	
  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end
end
