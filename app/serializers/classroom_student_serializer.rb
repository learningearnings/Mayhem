class ClassroomStudentSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :username, :is_homeroom, :classroom_id

  def username
    object.user.username
  end

  def is_homeroom
    psl = object.person_school_links.where(school_id: @options[:school_id]).first
    pscl = PersonSchoolClassroomLink.where(classroom_id: @options[:classroom_id], person_school_link_id: psl.id).first
    pscl.homeroom?
  end

  def classroom_id
    @options[:classroom_id]
  end
end
