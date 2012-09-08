require 'test_helper_with_rails'

describe Person do
  subject { Person }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "validates correctly" do
      p = subject.new()
      p.wont_be :valid?
      p.first_name = 'firname'
      p.wont_be :valid?
      p.last_name = 'lastname'
      p.must_be :valid?
    end
  end

  it "can receive a school" do
    school = FactoryGirl.create(:school)
    school.activate
    p = FactoryGirl.create(:person)
    p << school
    p.schools.must_include school
  end

  it "can receive a classroom" do
    school = FactoryGirl.create(:school)
    school.activate
    classroom = FactoryGirl.create(:classroom, school: school)
    p = FactoryGirl.create(:person)
    p << school
    p << classroom
    p.schools.must_include school
    p.classrooms.must_include classroom
  end
end
