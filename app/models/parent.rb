class Parent < Person

  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end

end
