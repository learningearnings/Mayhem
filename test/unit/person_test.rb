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

  describe "Person#display_name" do
    it "finds the most recent approved display name" do
      person = FactoryGirl.create(:person)
      first_display_name  = person.display_names.create(:display_name => "first")
      second_display_name = person.display_names.create(:display_name => "second")
      third_display_name  = person.display_names.creeate(:display_name => "third")

      second_display_name.approve!
      assert_equal person.display_name, second_display_name
    end

    it "should return a blank string if there are no display names" do
      person = FactoryGirl.create(:person)
      assert person.display_names.empty?
      assert_equal person.display_name, ""
    end
  end
end
