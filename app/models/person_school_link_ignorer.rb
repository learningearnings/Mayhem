# PersonSchoolLinkIgnorer simply sets the PersonSchoolLink ignored field to true,
#  but it also deactivates the PersonSchoolLink.
class PersonSchoolLinkIgnorer
  def initialize(person_school_link_id)
    @person_school_link = PersonSchoolLink.find(person_school_link_id)
  end

  def execute!
    @person_school_link.ignore = true
    @person_school_link.status = "inactive"
    @person_school_link.save(validate: false)
  end
end
