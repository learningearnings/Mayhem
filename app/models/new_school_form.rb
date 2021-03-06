class NewSchoolForm
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :state_id, :city, :teacher, :school
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
    @classrooms = teacher.classrooms.where(status: "active")    
    school = parent_school.dup
    school.assign_attributes(school_attributes, as: :admin)
    return false unless valid?
    
    school.store_subdomain = nil
    school.district_guid = nil
    school.sti_id = parent_school.id
    school.credits_type = "child"
    school.save
    
    PersonSchoolLink.where(person_id: teacher.id, status: "active").each do | psl |
      psl.status = "inactive"
      psl.save
    end
    psl = PersonSchoolLink.create(person_id: teacher.id, school_id: school.id, status: "active") 
    psl.save(:validate => false)   
          
    @students = []     
    @classrooms.each do | cr |
      classroom_creator = ClassroomCreator.new(cr.name, teacher, school)
      classroom_creator.execute!
      cr.students.each do | stu| 
        student = @students.detect { | lstu  | lstu.sti_id == stu.sti_id }
        if student == nil
          user = Spree::User.new(:username => stu.user.username, :password => stu.recovery_password, :password_confirmation => stu.recovery_password)
          student = Student.new
          student.first_name = stu.first_name
          student.last_name = stu.last_name
          student.dob = stu.dob
          student.grade = stu.grade
          student.sti_id = stu.sti_id
          student.user = user
          user.confirmed_at = Time.now
          user.save  
          student.save
          user.person_id = student.id
          user.save
          @students << student
        end
        psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(student.id, school.id)
        psl.status = "active"
        psl.save(:validate => false)
        pscl = PersonSchoolClassroomLink.find_or_create_by_classroom_id_and_person_school_link_id(classroom_creator.classroom.id, psl.id)
        pscl.activate
      end 
    end
          
    BuckDistributor.new([school]).run 
      
    @school = school
    @teacher = teacher
  end

  def school
    @school 
  end
  
  def teacher
    @teacher 
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