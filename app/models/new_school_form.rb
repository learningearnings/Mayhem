class NewSchoolForm
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :state_id, :city
  validates :name,                  presence: true
  validate  :uniqueness_of_school

  def initialize(attributes={})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  def self.model_name
    ActiveModel::Name.new(self, nil, "School")
  end
  
  def save(parent_school, teacher)
    school = parent_school.dup
    school.assign_attributes(school_attributes, as: :admin)
    return false unless valid?

    school.district_guid = nil
    school.credits_type = "child"
    school.save
    school.reload
    psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(teacher.id, school.id)
    @students = []
    teacher.classrooms.each do | cr |
      if (cr.status != "active") or (cr.students.size == 0)
        next
      end
      classroom_creator = ClassroomCreator.new(cr.name, teacher, school)
      classroom_creator.execute!
      cr.students.each do | stu| 
        student = @students.detect { | lstu  | lstu.sti_id == stu.sti_id }
        if student == nil
          user = Spree::User.new(:username => stu.user.username, :password => 'letemp', :password_confirmation => 'letemp')
          student = Student.new
          student.first_name = stu.first_name
          student.last_name = stu.last_name
          student.dob = stu.dob
          student.status = stu.status
          student.grade = stu.grade
          student.sti_uuid = stu.sti_uuid
          student.sti_id = stu.sti_id
          student.user = user
          user.save  
          student.save
          user.person_id = student.id
          user.username = stu.user.username
          user.save
          @students << student
        end
        psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(student.id, school.id)
        pscl = PersonSchoolClassroomLink.find_or_create_by_classroom_id_and_person_school_link_id(classroom_creator.classroom.id, psl.id)
        pscl.activate
      end 
    end
  end

  def school
    @school ||= School.new
  end
  
  def persisted?
    return false
  end


  def uniqueness_of_school
      if School.exists?(['LOWER(name) = LOWER(?) AND LOWER(city) = LOWER(?) AND state_id = ?', name, city, state_id])
        errors.add(:school, "is already registered")
      end
  end

  private
  def school_attributes
    { name: name, state_id: state_id, city: city}
  end
  
end
