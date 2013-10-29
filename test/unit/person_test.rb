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
    p = FactoryGirl.create(:student)
    p << school
    p.schools.must_include school
  end

  it "can receive a classroom" do
    school = FactoryGirl.create(:school)
    school.activate
    classroom = FactoryGirl.create(:classroom, school: school)
    p = FactoryGirl.create(:student)
    p << school
    p << classroom
    p.schools.must_include school
    p.classrooms.must_include classroom
  end

  it "has avatar as the last avatar" do
    p = FactoryGirl.create(:person)
    first_avatar = FactoryGirl.create(:avatar)
    last_avatar =  FactoryGirl.create(:avatar)
    p.avatar = first_avatar
    p.save
    p.avatar = last_avatar
    p.save
    p.avatars.count.must_equal 2
    p.avatars.must_include first_avatar
    p.avatars.must_include last_avatar
    p.avatar.must_equal last_avatar
  end
end
