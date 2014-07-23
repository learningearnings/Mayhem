class Parent < Person

  has_many :parent_student_links
  has_many :students, :through => :parent_student_links
  alias_method :children, :students

  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end
end
