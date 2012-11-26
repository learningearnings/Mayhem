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

  describe "Person#moniker" do
    it "finds the most recent approved moniker" do
      person = FactoryGirl.create(:person)
      first_moniker  = person.monikers.create(:moniker => "first")
      second_moniker = person.monikers.create(:moniker => "second")
      third_moniker  = person.monikers.create(:moniker => "third")

      second_moniker.approve!
      assert_equal person.moniker, second_moniker.moniker
    end

    it "should return a blank string if there are no monikers" do
      person = FactoryGirl.create(:person)
      assert person.monikers.empty?
      assert_equal person.moniker, ""
    end
  end

  describe "Person#moniker=" do
    it "should create a new moniker" do
      person = FactoryGirl.create(:person)
      assert_equal person.monikers.count, 0
      person.moniker= "New Moniker"
      person.save
      assert_equal person.monikers.count, 1
    end
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
