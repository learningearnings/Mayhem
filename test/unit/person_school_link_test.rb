require 'test_helper_with_rails'

describe PersonSchoolLink do
  subject {PersonSchoolLink}

  describe "Validations" do
 
    it "won't link a person if another person with the same username is already associated with the school" do
      school = FactoryGirl.create(:school)
      student1 = Student.create(:first_name => 'Student1', :last_name => 'Test', :grade => 1)
      student1.user.update_attributes(:username => 'student')
      student2 = Student.create(:first_name => 'Student2', :last_name => 'Test', :grade => 1)
      student2.user.update_attributes(:username => 'student')
      student1.school = school
      student2.school = school
      school.students.must_include(student1)
      school.students.wont_include(student2)
    end

    it "won't link a teacher if another person with the same email is already associated with the school" do
      school = FactoryGirl.create(:school)
      teacher1 = Teacher.create(:first_name => 'Teacher1', :last_name => 'Test', :grade => 1)
      teacher1.user.update_attributes(:email => 'teacher@school.com', :username => 'teacher1')
      teacher2 = Teacher.create(:first_name => 'Teacher2', :last_name => 'Test', :grade => 1)
      teacher2.user.update_attributes(:email => 'teacher@school.com', :username => 'teacher2')
      teacher1.school = school
      teacher2.school = school
      school.teachers.must_include(teacher1)
      school.teachers.wont_include(teacher2)
    end
 
 end

end
