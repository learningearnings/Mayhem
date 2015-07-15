class PersonSchoolLinkUnignorer
  def initialize(person_school_link_id)
    @person_school_link = PersonSchoolLink.find(person_school_link_id)
  end

  def execute!
    @person_school_link.ignore = false
    @person_school_link.status = "active"
    @person_school_link.save(validate: false)
  end
end
