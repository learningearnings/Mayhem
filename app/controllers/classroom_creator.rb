class ClassroomCreator
  def initialize(name, current_person, current_school)
    @name = name
    @current_person = current_person
    @current_school = current_school
  end

  def execute!
    update_owner_and_activate_classroom if classroom.save
  end

  def success?
    classroom.persisted?
  end

  def classroom
    @classroom ||= Classroom.new(name: @name, school_id: @current_school.id)
  end

  private

  def psl
    @psl = PersonSchoolLink.where(person_id: @current_person.id, school_id: @current_school.id).first_or_create
  end

  def pscl
    @pscl = PersonSchoolClassroomLink.where(classroom_id: classroom.id, person_school_link_id: psl.id).first_or_create
  end

  def update_owner_and_activate_classroom
    pscl.update_attributes({ owner: true, status: "active" })
  end
end
